import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3

Column{
    spacing: 5

    Rectangle{
        id: spacing
        height: 10
        width: devicewidth
        color: 'transparent'
    }

    Row{
        anchors.horizontalCenter: spacing.horizontalCenter
        spacing: 5
        Text{
            id: sensorid
            text: "Sensor Name: "
            font.pointSize: 16
            font.family: "Arial"
        }

        TextField{
            id: sensor_id
            text: "Device 1"
            font.pointSize: 16
            font.family: "Arial"
        }
    }

    Row{
        anchors.horizontalCenter: spacing.horizontalCenter
        spacing: 5
        Text{
            text: "Assigned Room: "
            font.pointSize: 16
            font.family: "Arial"
        }

        TextField{
            id: room
            text: "Room"
            validator: IntValidator{bottom: 1; top: 12}
            font.pointSize: 16
            font.family: "Arial"
        }
    }

    Row{
        anchors.horizontalCenter: spacing.horizontalCenter
        spacing: 5
        Text{
            text: "Sensor Number: "
            font.pointSize: 16
            font.family: "Arial"
        }

        TextField{
            id: number
            text: "1"
            validator: IntValidator{}
            font.pointSize: 16
            font.family: "Arial"
        }
    }

        Row {
            anchors.horizontalCenter: spacing.horizontalCenter
            spacing: 5
            Text{
                text: "Device Position: "
                font.pointSize: 16
                font.family: "Arial"
            }

            ExclusiveGroup { id: tabPositionGroup }
            RadioButton {
                id: top
                text: "Top"
                style: RadioButtonStyle {
                    label: Text{
                        font.family: "Arial"
                        font.pointSize: 16
                        text: control.text
                    }
                }
                checked: true
                exclusiveGroup: tabPositionGroup
            }
            RadioButton {
                id: bottom
                text: "Bottom"
                style: RadioButtonStyle {
                    label: Text{
                        font.family: "Arial"
                        font.pointSize: 16
                        text: control.text
                    }
                }
                exclusiveGroup: tabPositionGroup
            }
        }


    Rectangle{
        anchors.horizontalCenter: spacing.horizontalCenter
        color: '#68D5ED'
        height: text_id.height + 15
        width: text_id.width + 15
        Text{
            id: text_id
            text: "Add New"
            font.pointSize: 14
            font.family: "Arial"
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                add_device(sensor_id.text, room.text, number.text)
            }
        }
    }

    function add_device(device, room, number){
        var req = new XMLHttpRequest;
        req.open("POST", ip_addr + "/sensors", true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        if(top.checked){
            //send with top
            req.send(JSON.stringify({"sensor_id": device, "room": room, "goal_price": 50, "number": number, "location": "TOP"}));
        }
        else{
            //send with bottom
            req.send(JSON.stringify({"sensor_id": device, "room": room, "goal_price": 50, "number": number, "location": "BOT"}));
        }

        main.reload()
    }
}


