import QtQuick 2.0
import QtQuick.Controls 1.2

Column{
    //anchors.top: schedules.bottom
    Row{
        spacing: 5
        Text{
            id: sensorid
            text: "Sensor ID: "
            font.pointSize: 16
        }

        TextField{
            id: sensor_id
            text: "Device 1"
            font.pointSize: 16
        }
    }

    Row{
        spacing: 5
        Text{
            text: "Start Time: "
            font.pointSize: 16
        }

        TextField{
            id: starthour
            text: "Hour"
            validator: IntValidator{bottom: 1; top: 12}
            font.pointSize: 16
        }
        Text{
            id: starttime
            text: ":"
            font.pointSize: 16
        }
        TextField{
            id: startmin
            text: "Min"
            validator: IntValidator{bottom: 0; top: 59}
            font.pointSize: 16
        }
        ComboBox{
            id: ampm1
            width: 200
            model: ["AM", "PM"]
        }

        ComboBox{
            id: startday
            width: 200
            model: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        }
    }

    Row{
        spacing: 5
        Text{
            text: "End Time: "
            font.pointSize: 16
        }

        TextField{
            id: endhour
            text: "Hour"
            validator: IntValidator{bottom: 1; top: 12}
            font.pointSize: 16
        }
        Text{
            id: endtime
            text: ":"
            font.pointSize: 16
        }
        TextField{
            id: endmin
            text: "Min"
            validator: IntValidator{bottom: 0; top: 59}
            font.pointSize: 16
        }
        ComboBox{
            id: ampm2
            width: 200
            model: ["AM", "PM"]
        }

        ComboBox{
            id: endday
            width: 200
            model: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        }
    }

    Rectangle{
        color: 'lightgrey'
        height: text_id.height + 15
        width: text_id.width + 15
        Text{
            id: text_id
            text: "Add New"
            font.pointSize: 14
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                var sm = startmin.text
                var sh = starthour.text
                var em = endmin.text
                var eh = endhour.text
                calendarListView.add_schedule(calendarListView.time2int(sm, sh, ampm1.currentText),
                                              calendarListView.time2int(em, eh, ampm2.currentText),
                                              calendarListView.day2int(startday.currentText),
                                              calendarListView.day2int(endday.currentText),
                                              sensor_id.text)
                //opt = get_optimizations()
                //if(user wants optimizations){
                //display "notification"}
                //else{
                //put "notification" into file}
            }
            function get_optimizations(){
                var req = new XMLHttpRequest;
                req.open("GET", ip_addr + "/sensors", true);
                req.setRequestHeader("content-type", "application/json");
                req.setRequestHeader("accept", "application/json");
                req.responseType = "json"
                //console.debug("opened xmlHttpRequest")
                req.onreadystatechange = function() {
                    //console.debug("onreadystatechange")
                    status = req.readyState;
                    if (status === XMLHttpRequest.DONE) {
                        //console.debug("mystuff: ", req.responseText)
                        console.log(req.status)
                        var objectArray = JSON.parse(req.responseText);
                        if (objectArray.errors !== undefined)
                            console.log("Error fetching tweets: " + objectArray.errors[0].message)
                        else {
                            for (var key in objectArray) {
                                var jsonObject = objectArray[key];
                                devices.append(jsonObject);
                            }
                        }
                        if (wasLoading == true)
                            wrapper.isLoaded()
                        scheduleModel.reload()
                    }
                    wasLoading = (status === XMLHttpRequest.LOADING);
                }
                req.send();
            }
        }
    }
}


