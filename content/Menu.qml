import QtQuick 2.0

Item{
    id:menumenu
    property string menubarstate
    state: menubarstate//"DRAWER_CLOSED"

    Rectangle {
        id: root
        width: childrenRect.width //3*devicewidth/4
        height: deviceheight - mainheader.height
        color: "#eee9e9"
        //cdc9c9
        signal activated(string option)
        anchors.right: hide_menu.left
        y: mainheader.height

        Column{
            anchors.top: parent.top
            spacing: 5
            width: childrenRect.width//parent.width

            Rectangle{
                id: device
                width: Math.max(box.width, box2.width, box3.width, box5.width, mainheader.navbarwidth)
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
                        menubarstate = "DRAWER_CLOSED"
                    }
                }
            }
            Rectangle{
                id: room
                width: Math.max(box.width, box2.width, box3.width, box5.width, mainheader.navbarwidth)
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
                        menubarstate = "DRAWER_CLOSED"
                        root.activated("room")
                    }
                }
            }
            Rectangle{
                id: schedule
                width: Math.max(box.width, box2.width, box3.width, box5.width, mainheader.navbarwidth)
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
                        menubarstate = "DRAWER_CLOSED"
                    }
                }
            }

            Rectangle{
                id: settings
                width: Math.max(box.width, box2.width, box3.width, box5.width, mainheader.navbarwidth)
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
                        menubarstate = "DRAWER_CLOSED"
                        root.activated("settings")
                    }
                }
            }
        }
    }

    MouseArea{
        id: hide_menu
        height: mainheader.height + root.height
        width: devicewidth - root.width
        x: -hide_menu.width
        onClicked: state = 'DRAWER_CLOSED'
    }

    states: [
        State {
            name: "DRAWER_CLOSED"
            PropertyChanges { target: hide_menu; x: - hide_menu.width}
            PropertyChanges { target: mainheader; drawercolor: '#eee9e9'}
            PropertyChanges { target: mainheader; menucolor: '#eee9e9'}
        },
        State {
            name: "DRAWER_OPEN"
            PropertyChanges { target: hide_menu; x: root.width}
            PropertyChanges { target: mainheader; drawercolor: "#cdc9c9"}
            PropertyChanges { target: mainheader; menucolor: "#cdc9c9"}
        }
    ]
}
