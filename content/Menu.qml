import QtQuick 2.0


Rectangle {
    id: root
    width: childrenRect.width //3*devicewidth/4
    height: deviceheight - navbar.height
    color: "#eee9e9"
//cdc9c9
    signal activated(string option)

    Column{
        anchors.bottom: parent.bottom
        spacing: 5
        width: childrenRect.width//parent.width

        Rectangle{
            id: device
            width: Math.max(box.width, box2.width, box3.width, box4.width, box5.width, navbar.width)
            height: box.height + 15
            border.color: "#eee9e9"
            border.width: 5
            color: "#eee9e9"

            Text{
                id: box
                font.pointSize: 20
                font.family: "Arial"
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
            width: Math.max(box.width, box2.width, box3.width, box4.width, box5.width, navbar.width)
            height: box2.height + 15
            border.color: "#eee9e9"
            border.width: 5
            color: "#eee9e9"

            Text{
                id: box2
                font.pointSize: 20
                font.family: "Arial"
                text: "Rooms"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    main.state = "ROOM"
                    root.activated("room")
                }
            }
        }
        Rectangle{
            id: schedule
            width: Math.max(box.width, box2.width, box3.width, box4.width, box5.width, navbar.width)
            height: box3.height + 15
            border.color: "#eee9e9"
            border.width: 5
            color: "#eee9e9"

            Text{
                id:box3
                font.pointSize: 20
                text: "Schedule"
                font.family: "Arial"
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
            width: Math.max(box.width, box2.width, box3.width, box4.width, box5.width, navbar.width)
            height: box4.height + 15
            border.color: "#eee9e9"
            border.width: 5
            color: "#eee9e9"

            Text{
                id: box4
                font.pointSize: 20
                text: "Energy Use"
                font.family: "Arial"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    main.state = "ENERGY"
                    root.activated("energy")
                }
            }
        }

        Rectangle{
            id: settings
            width: Math.max(box.width, box2.width, box3.width, box4.width, box5.width, navbar.width)
            height: box5.height + 15
            border.color: "#eee9e9"
            border.width: 5
            color: "#eee9e9"

            Text{
                id: box5
                font.pointSize: 20
                font.family: "Arial"
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
