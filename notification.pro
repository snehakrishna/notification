QT += quick androidextras widgets

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

SOURCES += \
    main.cpp \
    notificationclient.cpp \
    internetconnection.cpp \
    internet_thread.cpp \
    device_model.cpp

OTHER_FILES += \
    qml/main.qml \
    android-sources/src/org/qtproject/example/notification/NotificationClient.java \
    android-sources/AndroidManifest.xml

RESOURCES += \
    main.qrc

HEADERS += \
    notificationclient.h \
    internetconnection.h \
    internet_thread.h \
    device_model.h
