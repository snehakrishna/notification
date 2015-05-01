/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtAndroidExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia. For licensing terms and
** conditions see http://qt.digia.com/licensing. For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights. These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/
//#include "../shared/shared.h"
//DECLARATIVE_EXAMPLE_MAIN(notification/main)

#include <QtGui>
#include <QtQuick>
#include <QScreen>
#include <QDebug>
#include <QObject>
#include <QtCore>
#include <QApplication>

#include "energygraph.h"

//#include "notificationclient.h"
//#include "internetconnection.h"
//#include "internet_thread.h"

#define DEBUG

int main(int argc, char **argv)
{
//    QGuiApplication app(argc, argv);
//    QScreen *screen = QGuiApplication::primaryScreen();
//    int height = screen->size().height();
//    int width = screen->size().width();

    QApplication app(argc, argv);
    QScreen *screen = QApplication::primaryScreen();
    int height = screen->size().height();
    int width = screen->size().width();

    QQuickView view;
    QTextStream output(stdout);

//    NotificationClient *notificationClient = new NotificationClient(&view);
//    view.engine()->rootContext()->setContextProperty(QLatin1String("notificationClient"),
//                                                     notificationClient);

    qmlRegisterType<EnergyGraph>("EnergyGraph", 1, 0, "EnergyGraph");
    view.engine()->rootContext()->setContextProperty(QLatin1String("screenHeight"),
                                                     height);
    view.engine()->rootContext()->setContextProperty(QLatin1String("screenWidth"),
                                                     width);
    view.resize(1000,1000);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.show();

    return app.exec();

//    if(isConnectedToNetwork()){
//        //notificationClient.notification = "You are connected to the internet. You will recieve new information.";
//        view.setResizeMode(QQuickView::SizeRootObjectToView);
//        view.setSource(QUrl(QStringLiteral("qrc:/qml/main.qml")));
//        view.show();

//        return app.exec();
//    }
//    else{
//        view.setResizeMode(QQuickView::SizeRootObjectToView);
//        view.setSource(QUrl(QStringLiteral("qrc:/qml/no_internet.qml")));
//        view.show();
//        return app.exec();
//    }

}
