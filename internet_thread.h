#ifndef INTERNET_THREAD_H
#define INTERNET_THREAD_H

#include <QMainWindow>
#include <QObject>
#include <QThread>
#include <QObject>
#include <QWidget>
#include "internetconnection.h"

class internet_thread : public QThread
{
    Q_OBJECT

    public:
        internet_thread();
        ~internet_thread();
    signals:
        void connected();
        void not_connected();
    protected:
        void run();
    private:
        volatile bool stopped;
};

#endif // INTERNET_THREAD_H
