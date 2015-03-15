import QtQuick 2.0


Rectangle {
    id: root
    width: 3*devicewidth/4
    height: deviceheight
    signal activated(string option)

        Column{
            anchors.bottom: parent.bottom
            spacing: 5
            width: parent.width

            Rectangle{
                id: device
                width: parent.width
                height: box.height + 15
                border.color: "black"
                border.width: 5

                Text{
                    id: box
                    width: parent.width
                    font.pointSize: 20
                    text: "Devices"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        root.activated("device")
                        main.state = "DEVICE"
                    }
                }
            }
            Rectangle{
                id: room
                width: parent.width
                height: box2.height + 15
                border.color: "black"
                border.width: 5

                Text{
                    id: box2
                    width: parent.width
                    font.pointSize: 20
                    text: "Rooms"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: root.activated("room")
                }
            }
            Rectangle{
                id: schedule
                width: parent.width
                height: box3.height + 15
                border.color: "black"
                border.width: 5

                Text{
                    id:box3
                    width: parent.width
                    font.pointSize: 20
                    text: "Schedule"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.activated("schedule")
                        main.state = "SCHEDULE"
                    }
                }
            }
            Rectangle{
                id: energy
                width: parent.width
                height: box4.height + 15
                border.color: "black"
                border.width: 5

                Text{
                    id: box4
                    width: parent.width
                    font.pointSize: 20
                    text: "Energy Use"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        main.state = "ENERGY"
                        root.activated("energy")
                }
            }
            Rectangle{
                id: settings
                width: parent.width
                height: box5.height + 15
                border.color: "black"
                border.width: 5

                Text{
                    id: box5
                    width: parent.width
                    font.pointSize: 20
                    text: "Settings"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        main.state = "SETTINGS"
                        root.activated("settings")
                    }
                }
            }
        }
    }
}

