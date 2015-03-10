import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    id: schedule
    width: devicewidth //Screen.width //
    height: deviceheight //Screen.height //

    property int inAnimDur: 250
    property int counter: 0
    property int counter_temp: 0

    property alias isLoading: scheduleModel.isLoading
    property var idx
    property var ids

    Component.onCompleted: { ids = new Array(); scheduleModel.reload()}

    function idsInModel(id)
    {
        for (var j = 0; j < ids.length; j++)
            if (ids[j] === id)
                return 1
        return 0
    }

    ScheduleModel {
        id: scheduleModel
        onIsLoaded: {
            console.debug("Reload schedule")
            idx = new Array()
            for (var i = 0; i < scheduleModel.model.count; i++) {
                var id = scheduleModel.model.get(i).id
                if (!idInModel(id))
                    idx.push(i)
            }
            console.debug(idx.length + " new device")
            schedule.counter = idx.length
            schedule.counter_temp = idx.length
        }
    }

    GridView {
        id: CalendarListView
        anchors.fill: parent
        delegate: ScheduleDelegate { }
        model: ListModel { id: week }
        cellWidth: parent.width / 2
        cellHeight: mainListView.cellWidth

        onDragEnded: if (header.refresh) {
                         clear()
                         devicesModel.reload() }

        ListHeader {
            id: header
            y: -mainListView.contentY - height
        }

        MainHeader{
            id: mainHeader
            anchors.top: header.bottom
        }

        function mainlistview_clear() {
            console.debug("clear")
            main.counter_temp--;
            var id = devicesModel.model.get(idx[main.counter]).id
            var item = devicesModel.model.get(main.counter)
            mainListView.add( { "sensor_id": item.sensor_id,
                                 "state": item.state});
            ids.push(id)
        }

        function clear() {
            ids = new Array()
            model.clear()
        }

        function add(obj) {
            model.insert(0, obj)
        }

    }

}
