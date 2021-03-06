import QtQuick 2.0
import QtQuick.Controls 1.2
import EnergyGraph 1.0

Item{
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        Component.onCompleted: console.log("in settings: ", width)
        Row {
            Text {
                id: energy_goal
                text: "Set New Energy Goal:"
                font.pointSize: 14
                font.family: "Arial"
            }
            TextField {
                id: energyGoal
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator { bottom: 0 }
                onAccepted: console.log("accepted: " + energyGoal.text)
                font.pointSize: 14
                font.family: "Arial"
            }
            Button {
                onClicked: (energyGoal.acceptableInput) ? updateEnergyGoal() : console.log("not acceptable");

                function updateEnergyGoal() {
                    var req = new XMLHttpRequest;
                    req.open("PUT", ip_addr + "/sensors/abc/updategoalprice", true);
                    req.setRequestHeader("content-type", "application/json");
                    req.setRequestHeader("accept", "application/json");
                    req.responseType = "json"
                    console.debug("opened xmlHttpRequest")
                    req.onreadystatechange = function() {
                        console.debug("onreadystatechange")
                        if (req.readyState === XMLHttpRequest.DONE) {
                            console.debug("Updated Energygoal");
                        }
                    }
                    var energyPrice = '{"goal_price":' + parseFloat(energyGoal.text) + ', "sensor_id":"abc"}';
                    req.send(energyPrice);
                }
            }
        }

        Row{
            spacing:10
            Text{
                text: "Energy Goal Notifications"
                font.pointSize: 14
                font.family: "Arial"
            }

            CheckBox{
                id: goals
                checked: true //setting in file
                onClicked: {
                    //write setting to file
                    if (checked == true){
                        var string = 'import QtQuick 2.0; Text {color: "red"; text: "Energy Goal Notifications On"; anchors.horizontalCenter: activity.horizontalCenter; y: 100}'
                        var newObject = Qt.createQmlObject(string , activity, "dynamicSnippet1");
                        newObject.destroy(2500);
                    }
                    else{
                        var string = 'import QtQuick 2.0; Text {color: "red"; text: "Energy Goal Notifications Off"; anchors.horizontalCenter: activity.horizontalCenter; y: 100}'
                        var newObject = Qt.createQmlObject(string, activity, "dynamicSnippet1");
                        newObject.destroy(2500);
                    }
                }
            }
        }
        Row {
            spacing:10
            Text{
                text: "Scheduling Optimization Notifications"
                font.pointSize: 14
                font.family: "Arial"
            }

            CheckBox{
                id: optimizations
                onClicked: {
                    //write setting to file
                    if (checked == true){
                        var string = 'import QtQuick 2.0; Text {color: "red"; text: "Scheduling Optimization Notifications On"; anchors.horizontalCenter: activity.horizontalCenter; y: 100}'
                        var newObject = Qt.createQmlObject(string , activity, "dynamicSnippet1");
                        newObject.destroy(2500);
                        //here create "notifications" from file
                    }
                    else{
                        var string = 'import QtQuick 2.0; Text {color: "red"; text: "Scheduling Optimization Notifications Off"; anchors.horizontalCenter: activity.horizontalCenter; y: 100}'
                        var newObject = Qt.createQmlObject(string, activity, "dynamicSnippet1");
                        newObject.destroy(2500);
                    }
                }
            }
        }
    }
}
