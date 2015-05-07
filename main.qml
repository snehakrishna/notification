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
    property string ip_addr: "http://10.1.6.56:8080"

    property int inAnimDur: 250
    property int counter: 0
    property int counter_temp: 0
    property int sched_count: 0
    property int sched_count_temp: 0
    property int room_count: 0
    property int room_count_temp: 0
    property alias isLoading: devicesModel.isLoading
    property var idx
    property var ids
    property var sensor_ids
    property var sensor_rooms
    property var sensor_states
    property var days
    property var dayx
    property var rooms
    property var roomx

    Component.onCompleted: {
        ids = new Array()
        days = new Array(7)
        rooms = new Array()
        timer.start()
        devicesModel.reload()
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

    function roomInModel(room)
    {
        for (var j = 0; j < rooms.length; j++)
            if (rooms[j] === room)
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
        rooms = new Array()
        mainListView.model.clear()
        calendarListView.model.clear()
        roomView.model.clear()
    }

    function add(obj){
        mainListView.model.insert(0, obj)
    }

    function sched_add(obj){
        calendarListView.model.insert(0,obj)
    }
    function room_add(obj){
        roomView.model.insert(0,obj)
    }

    Timer {
        id: timer
        interval: 500; running: main.counter; repeat: true
        onTriggered: {
            if (main.counter_temp == 0 && main.sched_count_temp == 0 && main.room_count_temp == 0){
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
            if (main.room_count_temp > 0){
                main.room_count_temp--;
                var room_name = roomModel.model.get(roomx[main.room_count_temp]).room
                var all_info = roomModel.model.get(main.room_count_temp)
                main.room_add({"room": all_info.room, "devices": all_info.devices})
                rooms.push(room_name)
            }
        }
    }

    DevicesModel {
        id: devicesModel
        onIsLoaded: {
            //console.debug("Reload")
            idx = new Array()
            sensor_ids = new Array()
            sensor_rooms = new Array()
            sensor_states = new Array()
            for (var i = 0; i < devicesModel.model.count; i++) {
                var id = devicesModel.model.get(i).id
                var room = devicesModel.model.get(i).room
                console.log(room)
                if (!idInModel(id)) {
                    sensor_ids.push(devicesModel.model.get(i).sensor_id)
                    sensor_rooms.push(devicesModel.model.get(i).room)
                    sensor_states.push(devicesModel.model.get(i).state)
                    idx.push(i)
                }
            }
            //console.debug(sensor_ids)
            //console.debug(idx.length + " new device")
            main.counter = idx.length
            main.counter_temp = idx.length

            if (main.counter == 0){
                var newObject = Qt.createQmlObject('import QtQuick 2.0; Text {color: "red"; font.family: "Arial"; font.pointsize: 12; text: "No internet connection"}',
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

    RoomsModel{
        id: roomModel
        onIsLoaded: {
            roomx = new Array()
            for (var i = 0; i < roomModel.model.count; i++){
                var room = roomModel.model.get(i).room
                if (!roomInmodel(room)){
                    roomx.push(i)
                }
            }
            main.room_count = roomx.length
            main.room_count_temp = roomx.length
        }
    }

    MainHeader{
        id: mainheader
        anchors.top: parent.top
        Component.onCompleted: {console.log("from mainheader ", mainheader.height)}
        drawercolor: '#eee9e9'
        menucolor: '#eee9e9'
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
            footer: AddDevice { }//footercomponent


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
            id: roomView
            anchors.fill: parent
            delegate: RoomsDelegate { }
            model: ListModel { id: rooms_list }
            interactive: true

            add: Transition {
                NumberAnimation { property: "hm"; from: 0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
                PropertyAction { property: "appear"; value: 250 }
            }

            onDragEnded: {
                if (header2.refresh) {
                    main.reload()
                }
            }

            ListHeader {
                id: header2
                y: -roomView.contentY - height - mainheader.height
            }

            function roomview_clear() {
                var counter = main.room_count
                //console.debug("clear")
                counter--;
                var id = roomModel.model.get(idx[counter]).id
                var item = roomModel.model.get(counter)
                roomview.add( { "sensor_id": item.room,
                                     "state": item.devices});
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
                if (header3.refresh) {
                    //console.log("in refresh calendar")
                    //clear()
                    //timer.start()
                    main.reload()
                }
            }

            footer: calendarfoot
            Component {
                id: calendarfoot
                ScheduleBox { }
            }

            ListHeader {
                id: header3
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
        Settings{
            id: settings
            anchors.fill: parent
        }
    }


    Menu{
        //anchors.top: mainheader.bottom
        id: menubar
        menubarstate: "DRAWER_CLOSED"
    }

    states: [
        State {
            name: "DEVICE"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: true }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: false }
            PropertyChanges { target: settings; visible: false }
            PropertyChanges { target: mainheader; disptitle: "Devices"}
            PropertyChanges { target: roomModel; visible:true }
            PropertyChanges { target: roomView; visible: false }
        },
        State {
            name: "SCHEDULE"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: false }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: true }
            PropertyChanges { target: settings; visible: false }
            PropertyChanges { target: mainheader; disptitle: "Schedule"}
            PropertyChanges { target: roomModel; visible:true }
            PropertyChanges { target: roomView; visible: false }
        },
        State {
            name: "SETTINGS"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: false }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: false }
            PropertyChanges { target: settings; visible: true }
            PropertyChanges { target: mainheader; disptitle: "Settings"}
            PropertyChanges { target: roomModel; visible:true }
            PropertyChanges { target: roomView; visible: false }
        },
        State {
            name: "ROOM"
            PropertyChanges { target: devicesModel; visible: true }
            PropertyChanges { target: mainListView; visible: false }
            PropertyChanges { target: scheduleModel; visible: true }
            PropertyChanges { target: calendarListView; visible: false }
            PropertyChanges { target: settings; visible: false }
            PropertyChanges { target: mainheader; disptitle: "Room"}
            PropertyChanges { target: roomModel; visible:true }
            PropertyChanges { target: roomView; visible: true }
        }
    ]
}
