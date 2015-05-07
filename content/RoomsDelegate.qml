import QtQuick 2.0
import QtQuick.Dialogs 1.2
import EnergyGraph 1.0

Item {
    id: container
    property real hm: 1.0
    property int appear: -1
    property real startRotation: 1

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false

    signal send()

    width: parent.width
    height: flipBar.height * hm


    MessageDialog {
        id: messageDialog
        onAccepted: visible = false
        Component.onCompleted: visible = false
    }

    Flipable {
        id: flipBar

        property bool flipped: false

        anchors.bottom: parent.bottom
        width: devicewidth
        height: childrenRect.height

        transform: Rotation {
            id: rotation
            origin.x: flipBar.width/2
            origin.y: flipBar.height/2
            axis.x: 0
            axis.y: 1
            axis.z: 0
            angle: 0
        }

        states: State {
            name: "BACK"
            PropertyChanges {
                target: rotation;
                angle: 180
            }
            when: flipBar.flipped
        }

        transitions: Transition {
            NumberAnimation {
                target: rotation
                property: "angle"
                duration: 500
            }
        }

        front: Rectangle {
            anchors.centerIn: parent
            height: childrenRect.height + 10
            border.color: "#8b8989"
            border.width: 5

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked");
                    flipBar.flipped = !flipBar.flipped;
                }
            }

            Text {
                id: roomname
                anchors.centerIn: parent
                text: model.room
                x: 10; y: 9
                font.pointSize: 20
                font.family: "Arial"
                font.bold: true
                color: "black"
            }
        }

        back:

        Rectangle {
            id: devicemodel2
            height: room.height + room.y + devices.height + 10
            width: devicewidth
            border.color: "#8b8989"
            border.width: 5
            property var devs: model.devices

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    flipBar.flipDown()
                    flipBar.flipped = false
                }
            }
            Text {
                id: room
                text: model.room
                anchors.horizontalCenter: parent.horizontalCenter
                y: 10
                font.pointSize: 20
                font.family: "Arial"
                font.bold: true
                color: "black"
                //Component.onCompleted: console.log(day.text)
            }
            Column{
                id: devices
                spacing: 10
                width: devicewidth - 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: room.bottom
                Repeater{
                    model: devicemodel2.devs
                    //Component.onCompleted: console.log(JSON.stringify(day_schedule.sched))
                    Text{
                        text: model.name
                        font.pointSize: 14
                        font.family: "Arial"
                        //Component.onCompleted: console.log(text)
                    }
                }
            }
        }
    }
}
