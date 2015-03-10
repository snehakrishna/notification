import QtQuick 2.0

Item {
    width: devicewidth/2
    height: deviceheight

    Rectangle{
        width: parent.width
        height: parent.height

        Column{
            anchors.bottom: parent.bottom
            spacing: 5
            Text{
                id: home
                font.pointSize: 16
                text: "Home Page"
            }
            Text{
                id: device
                text: "Devices"
            }
            Text {
                id: room
                text: qsTr("Rooms")
            }
            Text{
                id: schedule
                text: "Schedule"
            }
            Text{
                id: energy
                text: "Energy Use"

            }
            Text{
                id: settings
                text: "Settings"
            }
        }
    }
}

