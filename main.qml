import QtQuick 2.0
import QtQuick.Controls 1.3
import "content"
import EnergyGraph 1.0

Rectangle {
    id: main
    width: screenWidth
    height: screenHeight

    state: "DEVICE"

    property int devicewidth: width
    property int deviceheight: height
    property string ip_addr: "http://10.1.5.110:8080"

    property int inAnimDur: 250
    property int counter: 0
    property int counter_temp: 0
    property int sched_count: 0
    property int sched_count_temp: 0
    property alias isLoading: devicesModel.isLoading
    property var idx
    property var ids
    property var sensor_ids
    property var days
    property var dayx

    Component.onCompleted: {
        ids = new Array()
        days = new Array(7)
        timer.start()
        devicesModel.reload()
        console.log("height ", height)
        console.log("width ", width)
        console.log("device height ", deviceheight)
        console.log("device width ", devicewidth)
    }

    function idInModel(id)
    {
        for (var j = 0; j < ids.length; j++)
            if (ids[j] === id)
                return 1
        return 0
    }

    function dayInModel(day)
    {
        for (var j = 0; j < days.length; j++)
            if (days[j] === day)
                return 1
        return 0
    }

    function reload() {
        clear()
        timer.start()
        devicesModel.reload()
        //scheduleModel.reload()
    }

    function clear(){
        ids = new Array()
        days = new Array(7)
        mainListView.model.clear()
        calendarListView.model.clear()
    }

    function add(obj){
        mainListView.model.insert(0, obj)
    }

    function sched_add(obj){
        calendarListView.model.insert(0,obj)
    }

    Timer {
        id: timer
        interval: 500; running: main.counter; repeat: true
        onTriggered: {
            if (main.counter_temp == 0 && main.sched_count_temp == 0){
                timer.stop()
                return
            }
            if (main.counter_temp > 0){
                main.counter_temp--;
                var id = devicesModel.model.get(idx[main.counter_temp]).id
                var item = devicesModel.model.get(main.counter_temp)
                main.add( { "sensor_id": item.sensor_id,
                             "state": item.state});
                ids.push(id)
            }
            if (main.sched_count_temp > 0){
                main.sched_count_temp--;
                var day = scheduleModel.model.get(dayx[main.sched_count_temp]).day
                var sched = scheduleModel.model.get(main.sched_count_temp)
                //console.log("in main 66:")
                main.sched_add({"day": sched.day,
                                   "schedule": sched.schedule})
                days.push(day)
            }
        }
    }

    DevicesModel {
        id: devicesModel
        onIsLoaded: {
            //console.debug("Reload")
            idx = new Array()
            sensor_ids = new Array()
            for (var i = 0; i < devicesModel.model.count; i++) {
                var id = devicesModel.model.get(i).id
                if (!idInModel(id)) {
                    sensor_ids.push(devicesModel.model.get(i).sensor_id)
                    idx.push(i)
                }
            }
            //console.debug(sensor_ids)
            //console.debug(idx.length + " new device")
            main.counter = idx.length
            main.counter_temp = idx.length

            if (main.counter == 0){
                var newObject = Qt.createQmlObject('import QtQuick 2.0; Text {color: "red"; font.pointsize: 12; text: "No internet connection"}',
                                                   parentItem, "dynamicSnippet1");
            }
        }
    }

    ScheduleModel {
        id: scheduleModel
        onTrigger: {
            scheduleModel.sorting()
        }
        onIsLoaded: {
            //console.debug("Reload schedule")
            dayx = new Array()
            for (var i = 0; i < scheduleModel.model.count; i++) {
                var day = scheduleModel.model.get(i).day
                if (!dayInModel(day))
                    dayx.push(i)
            }
            //console.debug(dayx.length + " new schedule")
            main.sched_count = dayx.length
            main.sched_count_temp = dayx.length
        }

    }

    MainHeader{
        id: mainheader
        //disptitle: "Devices"
        //z: mainListView.z
        anchors.top: parent.top
        Component.onCompleted: {console.log("from mainheader ", mainheader.height)}
    }

    Flickable{
        //originX: 0
        //originY: 100
        interactive: false
        anchors.top: mainheader.bottom
        width: mainheader.width
        height: deviceheight - mainheader.height

        GridView {
            interactive: true
            y: deviceheight/10
            //anchors.top: mainheader.bottom
            Component.onCompleted: {console.log("from gridview ", mainheader.height)}
            id: mainListView
            anchors.fill: parent
            delegate: DevicesDelegate {}
            model: ListModel { id: finalModel }
            cellWidth: parent.width / 2
            cellHeight: mainListView.cellWidth
            //verticalLayoutDirection: ListView.BottomToTop
            //clip: true

            add: Transition {
                NumberAnimation { property: "hm"; from: 0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
                PropertyAction { property: "appear"; value: 250 }
            }

            //header: headercomponent
            footer: footercomponent

            onDragEnded: {
                if (header.refresh) {
                    //console.log("in refresh devices")
                    //clear()
                    //timer.start()
                    main.reload() }
            }

            ListHeader {
                id: header
                y: -mainListView.contentY - height - mainheader.height
            }

            //        Component{
            //            id: headercomponent
            //            MainHeader{
            //                disptitle: "Devices"
            //                z: mainListView.footerItem.z
            //            }
            //        }
            Component{
                id: footercomponent
                AddDevice {}
            }

            function mainlistview_clear() {
                var counter = main.counter
                //console.debug("clear")
                counter--;
                var id = devicesModel.model.get(idx[counter]).id
                var item = devicesModel.model.get(counter)
                mainListView.add( { "sensor_id": item.sensor_id,
                                     "state": item.state});
                ids.push(id)
            }

        }

        ListView {
            id: calendarListView
            anchors.fill: parent
            delegate: ScheduleDelegate { }
            model: ListModel { id: week }
            interactive: true

            onDragEnded: {
                if (header2.refresh) {
                    //console.log("in refresh calendar")
                    //clear()
                    //timer.start()
                    main.reload()
                }
            }

            /*
            header: MainHeader{
                id: mainHeader2
                disptitle: "Schedule"
            }*/

            footer: calendarfoot
            Component {
                id: calendarfoot
                ScheduleBox { }
            }

            ListHeader {
                id: header2
                y: -calendarListView.contentY - height - mainheader.height
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

            function add_schedule(starttime_t, endtime_t, startday_t, endday_t, sensor_id_t) {
                if (starttime_t == null || endtime_t == null){
                    //console.log("error")
                    return "error"
                }
                var sched_obj = {"sensor_id": sensor_id_t,
                    "starttime": starttime_t,
                    "startday": startday_t,
                    "endtime": endtime_t,
                    "endday": endday_t}
                var new_sched = { "sensor_id" : sensor_id_t, "schedules":[ sched_obj]};
                //console.log(new_sched);
                var req = new XMLHttpRequest;
                req.open("PUT", ip_addr + "/sensors/" + model.sensor_id);
                req.setRequestHeader("content-type", "application/json");
                req.setRequestHeader("accept", "application/json");
                req.responseType = "json"
                //console.debug("opened xmlHttpRequest")
                req.send(JSON.stringify(new_sched));
                main.reload()
            }

            function calendarlistview_clear() {
                var counter = main.sched_count
                //console.debug("clear sched")
                counter--;
                var id = scheduleModel.model.get(idx[counter]).id
                var item = scheduleModel.model.get(counter)
                main.add( { "sensor_id": item.sensor_id,
                             "state": item.state});
                ids.push(id)
            }

        }
    }
    Settings{ id: settings}

    states: [
        State {
            name: "DEVICE"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: true }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: false }
            PropertyChanges { target: settings; visible: false }
            PropertyChanges { target: mainheader; disptitle: "Devices"}
        },
        State {
            name: "SCHEDULE"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: false }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: true }
            PropertyChanges { target: settings; visible: false }
            PropertyChanges { target: mainheader; disptitle: "Schedule"}
        },
        State {
            name: "SETTINGS"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: false }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: false }
            PropertyChanges { target: settings; visible: true }
            PropertyChanges { target: mainheader; visible: false}
        }
        //        ,
        //        State {
        //            name: "ROOM"; when: mainListView.contentY >= -120
        //            PropertyChanges { target: arrow; rotation: 180 }
        //        },
        //        State {
        //            name: "ENERGY"; when: mainListView.contentY >= -120
        //            PropertyChanges { target: arrow; rotation: 180 }
        //        },
    ]
}

/*
    Column {
        anchors.fill: parent
        spacing: (height - happyButton.height - sadButton.height - title.height) / 3

        Text {
            id: title
            color: "black"
            font.pixelSize: parent.width / 20
            text: "How are you feeling?"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        Image {
            id: happyButton
            height: parent.height / 5
            fillMode: Image.PreserveAspectFit
            source: "../images/happy.png"
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true

            Behavior on scale {
                PropertyAnimation {
                    duration: 100
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: notificationClient.notification = "User is happy!"
                onPressed: happyButton.scale = 0.9
                onReleased: happyButton.scale = 1.0
            }
        }

        Image {
            id: sadButton
            height: parent.height / 5
            fillMode: Image.PreserveAspectFit
            source: "../images/sad.png"
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true

            Behavior on scale {
                PropertyAnimation {
                    duration: 100
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: notificationClient.notification = "User is sad :("
                onPressed: sadButton.scale = 0.9
                onReleased: sadButton.scale = 1.0
            }
        }
    }
    */
