import QtQuick 2.0


Item {
    id: container
    property real hm: 1.0
    property int appear: -1
    property real startRotation: 1

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false

    property string ip_addr: "http://10.1.10.167:8080"

    onAppearChanged: {
        container.startRotation = 0.5
        flipBar.animDuration = appear;
        delayedAnim.start();
    }

    SequentialAnimation {
        id: delayedAnim
        PauseAnimation { duration: 50 }
        ScriptAction { script: flipBar.flipDown(startRotation); }
    }

    width: parent.width
    height: flipBar.height * hm


    FlipBar {
        id: flipBar

        property bool flipped: false
        delta: startRotation

        anchors.bottom: parent.bottom
        width: container.GridView.view ? container.GridView.view.width : 0
        height: container.GridView.view ? container.GridView.view.height : 0

        front: Rectangle {
            width: container.GridView.view ? container.GridView.view.cellWidth : 0
            height: container.GridView.view ? container.GridView.view.cellHeight : 0
            border.color: "blue"
            border.width: 5

            Text {
                id: device
                text: model.sensor_id
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                x: 10; y: 9
                font.pointSize: 18
                font.bold: true
                color: "black"
            }
            Text {
                id: status
                text: model.state
                font.pointSize: 14
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: device.bottom
                }
            }
        }

        back: Rectangle {
            id: power_command
            width: container.ListView.view ? container.ListView.view.cellWidth : 0
            height: container.GridView.view ? container.GridView.view.cellHeight : 0
            color: "white"

            Text {
                id: device2
                text: model.sensor_id
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                x: 10; y: 9
                font.pointSize: 18
                font.bold: true
                color: "black"
            }
            Text {
                id: status2
                text: model.state
                font.pointSize: 14
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: device2.bottom
                }

                MouseArea{
                    id: send_command
                    width: parent.width
                    height: parent.height
                    onClicked: if (status2.text == "on") {
                                   power_command("off")
                               }
                               else{
                                   power_command("on")
                               }
                }
            }

            State: [
                State {
                    name: "OFF"; when: status2.text == "off"
                },
                State {
                    name: "ON"; when: status2.text == "on"
                }
            ]
        }
    }
    function power_command(state) {
        var req = new XMLHttpRequest;
        req.open("PUT", ip_addr + "/sensors/" + model.sensor_id, true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        console.debug("opened xmlHttpRequest")
        req.onreadystatechange = function() {
            console.debug("onreadystatechange")
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                //console.debug("mystuff: ", req.responseText)
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined)
                    console.log("Error fetching tweets: " + objectArray.errors[0].message)
                else {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        console.debug(objectArray[key].sensor_id)
                        devices.append(jsonObject);
                    }
                }
                if (wasLoading == true)
                    wrapper.isLoaded()
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        var power_data = '{ "state" : "' + state + '", "sensor_id":"' + model.sensor_id + '", "kwh":12 }';
        req.send(power_data);
    }
}

