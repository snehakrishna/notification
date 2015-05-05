#include "energygraph.h"
#include "qcustomplot.h"
#include <QDebug>
#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>

EnergyGraph::EnergyGraph( QQuickItem *parent ) : QQuickPaintedItem(parent), mCustomPlot(0)
{
    setFlag( QQuickItem::ItemHasContents, true);
    setAcceptedMouseButtons(Qt::AllButtons);

    connect( this, &QQuickPaintedItem::widthChanged, this, &EnergyGraph::updateCustomPlotSize);
    connect( this, &QQuickPaintedItem::heightChanged, this, &EnergyGraph::updateCustomPlotSize);
}

EnergyGraph::~EnergyGraph()
{
    delete mCustomPlot;
    mCustomPlot = 0;
}

void EnergyGraph::initEnergyGraph(QString ipAddr, QString sensorId)
{
    this->mIpAddr = ipAddr;
    this->mSensorId = sensorId;
    mCustomPlot = new QCustomPlot();
    updateCustomPlotSize();
    setupEnergyGraph(mCustomPlot);
//    setupQuadraticDemo(mCustomPlot);
    connect(mCustomPlot, &QCustomPlot::afterReplot, this, &EnergyGraph::onCustomReplot);
    mCustomPlot->replot();
}

void EnergyGraph::setTime(int months) {
    if (!mCustomPlot) {
        qDebug() << "Call initEnergyGraph first";
        return;
    }
    if (months > 12) {
        qDebug() << "Time only goes to a year";
        return;
    }
    int currentTime = QDateTime::currentDateTime().toTime_t();
    int monthStart = QDateTime::currentDateTime().addMonths(-1*months).toTime_t();
    mCustomPlot->xAxis->setRange(monthStart, currentTime);
    mCustomPlot->xAxis->setTickStep((currentTime-monthStart)/20);
    mCustomPlot->yAxis->rescale();
    mCustomPlot->replot();
}

void EnergyGraph::paint(QPainter* painter)
{
    if (mCustomPlot)
    {
        QPixmap picture( boundingRect().size().toSize());
        QCPPainter qcpPainter(&picture);

        mCustomPlot->toPainter(&qcpPainter);
        painter->drawPixmap(QPoint(), picture);
    }
}

void EnergyGraph::updateCustomPlotSize()
{
    if (mCustomPlot)
    {
        mCustomPlot->setGeometry(0, 0, width(), height() );
    }
}

void EnergyGraph::onCustomReplot()
{
    update();
}

void EnergyGraph::setupEnergyGraph( QCustomPlot* customPlot)
{
    QCPAxisRect *axisRect = customPlot->axisRect();

    double price = getEnergyGoal();
    double currentPrice = 0;
    QVector<energyHistory> energyHistories = getEnergyHistories();

    QVector<double> x(2), y(2); // start and end for each
    QVector<double> xl(energyHistories.size() * 2), yl(energyHistories.size() * 2);

    //setting for past month - year
    double lastMonthTime = QDateTime::currentDateTime().addMonths(-1).toTime_t();

    x[0] = 0;
    x[1] = QDateTime::currentDateTime().toTime_t();

    y[0] = price;
    y[1] = price;

    for(int i = 0; i < energyHistories.size(); i++) {
        xl[i*2] = (energyHistories[i].startTime);
        yl[i*2] = currentPrice;

        currentPrice += energyHistories[i].price;
        xl[i*2+1] = (energyHistories[i].endTime);
        yl[i*2+1] = currentPrice;
    }
    maxYVal = currentPrice;
    customPlot->addGraph();
    customPlot->graph(0)->setPen(QPen(Qt::red));
    customPlot->graph(0)->setData(x, y);

    customPlot->addGraph();
    customPlot->graph(1)->setPen(QPen(Qt::green));
    customPlot->graph(1)->setData(xl, yl);

    customPlot->rescaleAxes();
}


void EnergyGraph::setupQuadraticDemo( QCustomPlot* customPlot )
{
    // make top right axes clones of bottom left axes:
    QCPAxisRect* axisRect = customPlot->axisRect();

    // generate some data:
    QVector<double> x( 101 ), y( 101 );   // initialize with entries 0..100
    QVector<double> lx( 101 ), ly( 101 ); // initialize with entries 0..100
    for (int i = 0; i < 101; ++i)
    {
        x[i] = i / 50.0 - 1;              // x goes from -1 to 1
        y[i] = x[i] * x[i];               // let's plot a quadratic function

        lx[i] = i / 50.0 - 1;             //
        ly[i] = lx[i];                    // linear
    }
    // create graph and assign data to it:
    customPlot->addGraph();
    customPlot->graph( 0 )->setPen( QPen( Qt::red ) );
    customPlot->graph( 0 )->setSelectedPen( QPen( Qt::blue, 2 ) );
    customPlot->graph( 0 )->setData( x, y );

    customPlot->addGraph();
    customPlot->graph( 1 )->setPen( QPen( Qt::magenta ) );
    customPlot->graph( 1 )->setSelectedPen( QPen( Qt::blue, 2 ) );
    customPlot->graph( 1 )->setData( lx, ly );

    double xmin = -1;
    double xmax = 1;

    // give the axes some labels:
    customPlot->xAxis->setLabel( "x" );
    customPlot->yAxis->setLabel( "y" );
    // set axes ranges, so we see all data:
    customPlot->xAxis->setRange( xmin, xmax );
    customPlot->xAxis->setAutoTickStep(false);
    customPlot->xAxis->setTickStep((xmax - xmin)/20);
    customPlot->yAxis->setRange( -1, 1 );
//    customPlot ->setInteractions( QCP::iRangeDrag | QCP::iRangeZoom | QCP::iSelectPlottables );
}

double EnergyGraph::getEnergyGoal() {
    double goal = -1;
    
    QEventLoop eventLoop;

    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply *)), &eventLoop, SLOT(quit()));
    QNetworkRequest req( QUrl(mIpAddr + QString("/sensors/") + this->mSensorId + QString("/energygoal")));
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec();

    if (reply->error() == QNetworkReply::NoError)
    {        
        QJsonDocument jsonResponse = QJsonDocument::fromJson(reply->readAll());
        QJsonObject jsonObject = jsonResponse.object();

        goal = jsonObject["goal_price"].toDouble();
        
    } else {
        qDebug() << "Error: " << reply->readAll();
    }
    delete reply;
    return goal;
}

QVector<energyHistory> EnergyGraph::getEnergyHistories() {
    QVector<energyHistory> energyHistories = QVector<energyHistory>();

    QEventLoop eventLoop;

    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply *)), &eventLoop, SLOT(quit()));

    QNetworkRequest req( QUrl(  mIpAddr + QString("/sensors/") + this->mSensorId + QString("/energyhistories")));
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec();

    if (reply->error() == QNetworkReply::NoError)
    {
        QJsonDocument jsonResponse = QJsonDocument::fromJson(reply->readAll());
        QJsonArray jsonArray = jsonResponse.array();
        foreach (const QJsonValue & v, jsonArray) {
            QJsonObject object = v.toObject();

            //ignore current energyhistory
            if (object["end_time"].toString() == "")
                continue;
            energyHistories.push_back(energyHistory());
            int size = energyHistories.size()-1;
            energyHistories[size].startTime = QDateTime::fromString(object["start_time"].toString(), Qt::ISODate).toTime_t();
            energyHistories[size].endTime = QDateTime::fromString(object["end_time"].toString(), Qt::ISODate).toTime_t();
            energyHistories[size].price = object["price_per_kwh"].toDouble() * object["kwh"].toDouble();
        }
    } else {
        qDebug() << "Error: " << reply->readAll();
    }
    delete reply;
    return energyHistories;
}
