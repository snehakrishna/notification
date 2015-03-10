#ifndef ENERGYGRAPH_H
#define ENERGYGRAPH_H

#include <QtQuick>

class QCustomPlot;

struct energyHistory {
    int startTime;
    int endTime;
    double price;
};

class EnergyGraph : public QQuickPaintedItem
{
    Q_OBJECT
public:
    EnergyGraph(QQuickItem *parent = 0);
    virtual ~EnergyGraph();

    void paint( QPainter* painter);

    Q_INVOKABLE void initEnergyGraph();

protected:
    void setupQuadraticDemo( QCustomPlot* customPlot);
    void setupEnergyGraph( QCustomPlot* customPlot);

private:
    QCustomPlot* mCustomPlot;
    float maxYVal;

    double getEnergyGoal();
    QVector<energyHistory> getEnergyHistories();

private slots:
    void onCustomReplot();
    void updateCustomPlotSize();
};

#endif // ENERGYGRAPH_H
