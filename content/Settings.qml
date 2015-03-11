import QtQuick 2.0
import QtQuick.Controls 1.2
import EnergyGraph 1.0

Activity {
    interior: Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Row {
            Text {
                id: energy_goal
                text: "Set New Energy Goal:"
            }
            TextField {
                id: energyGoal
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator { bottom: 0 }
                onAccepted: console.log("accepted: " + energyGoal.text)
            }
            Button {
                onClicked: (energyGoal.acceptableInput) ? updateEnergyGoal() : console.log("not acceptable");

                function updateEnergyGoal() {
                    var req = new XMLHttpRequest;
                    req.open("PUT", "http://10.1.4.248:8080/sensors/abc/updategoalprice", true);
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


        Text{
            text: "Energy Goal Notifications"
        }

        Text{
            text: "Scheduling Optimization Notifications"
        }
    }
}
