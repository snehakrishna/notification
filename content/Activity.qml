import QtQuick 2.0

Item {
    anchors.fill: parent
    MainHeader{}
    property alias interior : loader.sourceComponent

    Loader {
        anchors.centerIn: parent
        id: loader
    }
}
