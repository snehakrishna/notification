TEMPLATE = app

QT += quick qml widgets printsupport
SOURCES += main.cpp \
    qcustomplot.cpp \
    energygraph.cpp
RESOURCES += main.qrc

OTHER_FILES = main.qml \
              content/*.qml \
              content/*.js \
              content/resources/*

target.path = $$[QT_INSTALL_EXAMPLES]/androidextras/notification
INSTALLS += target

#QT += quick androidextras widgets

#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

#SOURCES += \
#    main.cpp \
#    notificationclient.cpp \
#    internetconnection.cpp \
#    internet_thread.cpp \
#    device_model.cpp

#OTHER_FILES += \
#    android-sources/src/org/qtproject/example/notification/NotificationClient.java \
#    android-sources/AndroidManifest.xml

#RESOURCES += \
#    main.qrc

#HEADERS += \
#    notificationclient.h \
#    internetconnection.h \
#    internet_thread.h \
#    device_model.h

#DISTFILES += \
#    content/DevicesModel.qml \
#    main.qml

HEADERS += \
    qcustomplot.h \
    energygraph.h
