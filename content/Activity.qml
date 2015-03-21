import QtQuick 2.0

Item {
    anchors.fill: parent
    property string title
    MainHeader{
        disptitle: title
    }
    property alias interior : loader.sourceComponent

    Loader {
        anchors.centerIn: parent
        id: loader
    }
}
