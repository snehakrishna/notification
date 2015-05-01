import QtQuick 2.0
import QtQuick.Controls 1.2

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
        }

        TextField{
            id: sensor_id
            text: "Device 1"
            font.pointSize: 16
        }
    }

    Row{
        anchors.horizontalCenter: spacing.horizontalCenter
        spacing: 5
        Text{
            text: "Assigned Room: "
            font.pointSize: 16
        }

        TextField{
            id: room
            text: "Room"
            validator: IntValidator{bottom: 1; top: 12}
            font.pointSize: 16
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
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                add_device(sensor_id.text, room.text)
            }
        }
    }

    function add_device(device, room){
        var req = new XMLHttpRequest;
        req.open("POST", ip_addr + "/sensors", true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        req.send(JSON.stringify({"sensor_id": device, "room": room, "goal_price": 50}));
        main.reload()
    }
}


