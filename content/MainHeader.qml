import QtQuick 2.0

Item{
    id: screen
    state: "DRAWER_CLOSED"
    property string disptitle
    height: deviceheight/10
    width: devicewidth

    Component.onCompleted: console.log("in MainHeader ", deviceheight)

    Rectangle {
        id: titlerect
        width: devicewidth
        height: deviceheight/10
        color: '#eee9e9'

        Text{
            id: title
            text: disptitle
            font.pointSize: 20
            font.family: "Arial"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle{
            id: drawer
            width: parent.height + menu.width
            height: parent.height
            color: '#eee9e9'
            anchors.left: parent.left

            Image{
                id: ic_drawer
                width: parent.height
                height: parent.height
                fillMode: Image.PreserveAspectFit
                source: "../images/ic_menu_black_48dp.png"
                anchors.left: parent.left
            }

            Text{
                id: menu
                text: "Menu"
                anchors.left: ic_drawer.right
                font.pointSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea{
                id: navbar
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
        anchors.top: titlerect.bottom
        anchors.right: hide_menu.left
        id: menubar
        onActivated: {
            screen.state = "DRAWER_CLOSED"
            //console.log(option)
        }
    }
    MouseArea{
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
            PropertyChanges { target: drawer; color: '#eee9e9'}
        },
        State {
            name: "DRAWER_OPEN"
            PropertyChanges { target: hide_menu; x: menubar.width}
            //PropertyChanges { target: hide_menu; z: 3}
            PropertyChanges { target: screen; height: menubar.height}
            PropertyChanges { target: drawer; color: "#cdc9c9"}
        }
    ]

    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: menubar; properties: "x"; duration: 500; easing.type: Easing.OutExpo }
        }
    ]

}
