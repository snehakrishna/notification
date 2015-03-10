#include "energygraph.h"
#include "qcustomplot.h"
#include <QDebug>
#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>

#define IP "10.1.10.167"



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

void EnergyGraph::initEnergyGraph()
{
    mCustomPlot = new QCustomPlot();
    updateCustomPlotSize();
    setupEnergyGraph(mCustomPlot);
//    setupQuadraticDemo(mCustomPlot);
    connect(mCustomPlot, &QCustomPlot::afterReplot, this, &EnergyGraph::onCustomReplot);
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
    qDebug() << Q_FUNC_INFO;
    update();
}

void EnergyGraph::setupEnergyGraph( QCustomPlot* customPlot)
{
    qDebug() << Q_FUNC_INFO;
    QCPAxisRect *axisRect = customPlot->axisRect();

    double price = getEnergyGoal();
    double currentPrice = 0;
    QVector<energyHistory> energyHistories = getEnergyHistories();

    QVector<double> x(energyHistories.size() * 2), y(energyHistories.size() * 2); // start and end for each
    QVector<double> xl(energyHistories.size() * 2), yl(energyHistories.size() * 2);

    //setting for past month - year
    double lastMonthTime = QDateTime::currentDateTime().addMonths(-1).toTime_t();

    for(int i = 0; i < energyHistories.size(); i++) {
        x[i*2] = (energyHistories[i].startTime - lastMonthTime) / 1000/60/60/24;
        y[i*2] = price;
        x[i*2+1] = (energyHistories[i].endTime - lastMonthTime) / 1000/60/60/24;
        y[i*2+1] = price;

        xl[i*2] = (energyHistories[i].startTime - lastMonthTime) / 1000/60/60/24;
        yl[i*2] = currentPrice;

        currentPrice += energyHistories[i].price;
        qDebug() << y[i*2];
        xl[i*2+1] = (energyHistories[i].endTime - lastMonthTime) / 1000/60/60/24;
        yl[i*2+1] = currentPrice;
    }
    customPlot->addGraph();
    customPlot->graph(0)->setPen(QPen(Qt::red));
    customPlot->graph(0)->setData(x, y);

    customPlot->addGraph();
    customPlot->graph(1)->setPen(QPen(Qt::green));
//    customPlot->graph( 1 )->setSelectedPen( QPen( Qt::blue, 2 ) );
    customPlot->graph(1)->setData(xl, yl);

    customPlot->rescaleAxes();
}


void EnergyGraph::setupQuadraticDemo( QCustomPlot* customPlot )
{
    qDebug() << Q_FUNC_INFO;

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

    // give the axes some labels:
    customPlot->xAxis->setLabel( "x" );
    customPlot->yAxis->setLabel( "y" );
    // set axes ranges, so we see all data:
    customPlot->xAxis->setRange( -1, 1 );
    customPlot->yAxis->setRange( -1, 1 );
//    customPlot ->setInteractions( QCP::iRangeDrag | QCP::iRangeZoom | QCP::iSelectPlottables );
}

double EnergyGraph::getEnergyGoal() {
    double goal = -1;
    
    QEventLoop eventLoop;

    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply *)), &eventLoop, SLOT(quit()));

    QNetworkRequest req( QUrl( QString("http://10.1.9.52:8080/sensors/abc/energygoal")));
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec();

    if (reply->error() == QNetworkReply::NoError)
    {
        qDebug() << "Success: ";
        
        QJsonDocument jsonResponse = QJsonDocument::fromJson(reply->readAll());
        QJsonObject jsonObject = jsonResponse.object();
        qDebug() << "Returning " << jsonObject["goal_price"].toString();

        goal = jsonObject["goal_price"].toDouble();
        
    } else {
        qDebug() << "Error: " << reply->readAll();
    }
    delete reply;
    qDebug() << "Returning " << goal;
    return goal;
}

QVector<energyHistory> EnergyGraph::getEnergyHistories() {
    QVector<energyHistory> energyHistories = QVector<energyHistory>();

    QEventLoop eventLoop;

    QNetworkAccessManager mgr;
    QObject::connect(&mgr, SIGNAL(finished(QNetworkReply *)), &eventLoop, SLOT(quit()));

    QNetworkRequest req( QUrl( QString("http://10.1.9.52:8080/sensors/abc/energyhistories")));
    QNetworkReply *reply = mgr.get(req);
    eventLoop.exec();

    if (reply->error() == QNetworkReply::NoError)
    {
        qDebug() << "Success: ";

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
