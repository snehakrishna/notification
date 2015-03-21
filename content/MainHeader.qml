import QtQuick 2.0

Item{
    id: screen
    signal activate(string option)
    state: "DRAWER_CLOSED"
    property string disptitle

    Rectangle {
        z: 0
        width: devicewidth
        height: deviceheight/10
        color: '#00FF00'

        Text{
            id: title
            text: disptitle
            font.pointSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

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
                font.pointSize: 20
                anchors.verticalCenter: parent.verticalCenter
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
        onActivated: {
            //screen.activate(option)
            screen.state = "DRAWER_CLOSED"
            //console.log(option)
        }
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
            name: "DRAWER_CLOSED"
            PropertyChanges { target: hide_menu; x: - hide_menu.width}
        },
        State {
            name: "DRAWER_OPEN"
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
