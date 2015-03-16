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
            //Component.onCompleted: console.log(day.text)
        }

        Column{
            id: schedules
            spacing: 10
            anchors.top: day.bottom
            Repeater{
                model: day_schedule.sched
                //Component.onCompleted: console.log(JSON.stringify(day_schedule.sched))
                Text{
                    text: model.sensor_id + ":\t" + container.int2time(model.starttime)
                          + " -- " + container.int2time(model.endtime)
                    font.pointSize: 14
                    //Component.onCompleted: console.log(text)
                }
            }
        }
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

