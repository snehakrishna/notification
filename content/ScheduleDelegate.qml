import QtQuick 2.0
import QtQuick.Controls 1.3

Item {
    id: container
    property real hm: 1.0
    //    property int appear: -1
    //    property real startRotation: 1
    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    width: parent.width
    height: day_schedule.height

    Rectangle {
        id: day_schedule
        width: container.ListView.view ? container.ListView.view.width : 0
        height: day.height + day.y + schedules.height //+ inputstuff.height//children.height
        border.color: "blue"
        border.width: 5
        property var sched: model.schedule

        Text {
            id: day
            text: container.int2day(model.day)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10
            font.pointSize: 36
            font.bold: true
            color: "black"
            Component.onCompleted: console.log(day.text)
        }

        Column{
            id: schedules
            spacing: 10
            anchors.top: day.bottom
            Repeater{
                model: day_schedule.sched
                Component.onCompleted: console.log(JSON.stringify(day_schedule.sched))
                Text{
                    text: model.sensor_id + ":\t" + container.int2time(model.starttime)
                          + " -- " + container.int2time(model.endtime)
                    font.pointSize: 14
                    Component.onCompleted: console.log(text)
                }
            }
        }
        /*Column{
            id: inputstuff
            anchors.top: schedules.bottom
            Row{
                spacing: 5
                Text{
                    id: sensorid
                    text: "Sensor ID: "
                    font.pointSize: 16
                }

                TextInput{
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

                TextInput{
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
                TextInput{
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

                TextInput{
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
                TextInput{
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
                        container.add_schedule(container.time2int(sm, sh, ampm1.currentText),
                                               container.time2int(em, eh, ampm2.currentText),
                                               container.day2int(startday.currentText),
                                               container.day2int(endday.currentText),
                                               sensor_id.text)
                    }
                }
            }
        }*/
    }

    function add_schedule(starttime_t, endtime_t, startday_t, endday_t, sensor_id_t) {
        if (starttime_t == null || endtime_t == null){
            console.log("error")
            return "error"
        }
        var sched_obj = {"sensor_id": sensor_id_t,
            "starttime": starttime_t,
            "startday": startday_t,
            "endtime": endtime_t,
            "endday": endday_t}
        var new_sched = '{ "sensor_id" : "' + sensor_id_t
                + '", "schedules":["' + JSON.stringify(sched_obj) + ']}';
        console.log(new_sched);
        var req = new XMLHttpRequest;
        req.open("PUT", ip_addr + "/sensors/" + model.sensor_id, true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        console.debug("opened xmlHttpRequest")
        req.send(new_sched);
    }

    function time2int (m, h, am){
        var hour, time
        if (h == 12){
            hour = 0
        }
        else{
            hour = +h
        }
        time = hour*60 + (+m)
        if (am == "PM")
            time = time + 720
        return time
    }

    function int2time (m){
        if (m === 0)
            return "12:00 AM"
        else if (m === 1339)
            return "11:59 PM"
        else if (m < 720){
            var hour = Math.floor(m/60)
            if (hour == 0)
                hour = 12
            var min = m % 60
            if (min == 0)
                min = "00"
            return hour + ":" + min + " AM"
        }
        else{
            m = m - 720
            var hour = Math.floor(m/60)
            if (hour == 0)
                hour = 12
            var min = m % 60
            if (min == 0)
                min = "00"
            return hour + ":" + min + " PM"
        }
    }

    function day2int(day){
        switch (day){
        case "Sunday":
            return 0
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        default:
            return -1
        }
    }

    function int2day (i){
        switch (i){
        case 0:
            return "Sunday";
        case 1:
            return "Monday";
        case 2:
            return "Tuesday";
        case 3:
            return "Wednesday";
        case 4:
            return "Thursday";
        case 5:
            return "Friday";
        case 6:
            return "Saturday";
        default:
            return "Error in Day"
        }
    }
}

