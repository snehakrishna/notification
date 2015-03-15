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
}

