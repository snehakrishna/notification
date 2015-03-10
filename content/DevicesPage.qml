import QtQuick 2.0

Item{
    property int inAnimDur: 250
    property int counter: 0
    property int counter_temp: 0
    property alias isLoading: devicesModel.isLoading
    property var idx
    property var ids

    Component.onCompleted: { ids = new Array(); devicesModel.reload()}

    function idInModel(id)
    {
        for (var j = 0; j < ids.length; j++)
            if (ids[j] === id)
                return 1
        return 0
    }

    DevicesModel {
        id: devicesModel
        onIsLoaded: {
            console.debug("Reload")
            idx = new Array()
            for (var i = 0; i < devicesModel.model.count; i++) {
                var id = devicesModel.model.get(i).id
                if (!idInModel(id))
                    idx.push(i)
            }
            console.debug(idx.length + " new device")
            counter = idx.length
            counter_temp = idx.length

            //            if (main.counter == 0){
            //                var newObject = Qt.createQmlObject('import QtQuick 2.0; Text {color: "red"; font.pointsize: 12; text: "No internet connection"}',
            //                    parentItem, "dynamicSnippet1");
            //            }
        }
    }

    Timer {
        id: timer
        interval: 500; running: counter; repeat: true
        onTriggered: {
            console.debug("Triggered")
            counter--;
            var id = devicesModel.model.get(idx[counter]).id
            var item = devicesModel.model.get(counter)
            mainListView.add( { "sensor_id": item.sensor_id,
                                 "state": item.state});
            ids.push(id)
        }
    }

    GridView {
        id: mainListView
        anchors.fill: parent
        delegate: DevicesDelegate { }
        model: ListModel { id: finalModel }
        cellWidth: parent.width / 2
        cellHeight: mainListView.cellWidth

        add: Transition {
            NumberAnimation { property: "hm"; from: 0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
            PropertyAction { property: "appear"; value: 250 }
        }

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
            counter_temp--;
            var id = devicesModel.model.get(idx[counter]).id
            var item = devicesModel.model.get(counter)
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
