import QtQuick 2.0

Item{
    id: screen

    Rectangle {
        z: 0
        width: devicewidth
        height: deviceheight/10
        color: '#00FF00'

        Rectangle{
            id: drawer
            width: parent.height
            height: parent.height
            color: '#00FF00'
            anchors.left: parent.left

            Image{
                id: ic_drawer
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                source: "../images/drawer/ic_drawer.png"
            }

            Text{
                id: menu
                text: "MENU"
                anchors.left: drawer.right
            }

            MouseArea{
                anchors.left: ic_drawer.left
                anchors.right: menu.right
                anchors.top: drawer.top
                anchors.bottom: drawer.bottom
                onClicked:{
                    if (screen.state == "DRAWER_CLOSED"){
                        screen.state = "DRAWER_OPEN"
                    }
                    else if (screen.state == "DRAWER_OPEN"){
                        screen.state = "DRAWER_CLOSED"
                    }
                }
            }
        }
    }

    Menu{
        z: 1
        anchors.right: hide_menu.left
        id: menubar
    }
    MouseArea{
        z: 1
        id: hide_menu
        height: menubar.height
        width: devicewidth - menubar.width
        x: -hide_menu.width
        onClicked: screen.state = 'DRAWER_CLOSED'
    }

    states: [
        State {
            name: "DRAWER_CLOSED"; when: hide_menu.x == - hide_menu.width
            PropertyChanges { target: hide_menu; x: - hide_menu.width}
        },
        State {
            name: "DRAWER_OPEN"; when: hide_menu.x == menubar.width
            PropertyChanges { target: hide_menu; x: menubar.width}
        }
    ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: menubar; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
        }
    ]
}
