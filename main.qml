import QtQuick 2.0
import "content"
import EnergyGraph 1.0

Rectangle {
    id: main
    width: width
    height: height
    color: "white"

    property int devicewidth: width
    property int deviceheight: height

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
            main.counter = idx.length
            main.counter_temp = idx.length

//            if (main.counter == 0){
//                var newObject = Qt.createQmlObject('import QtQuick 2.0; Text {color: "red"; font.pointsize: 12; text: "No internet connection"}',
//                    parentItem, "dynamicSnippet1");
//            }
        }
    }

    Timer {
        id: timer
        interval: 500; running: main.counter; repeat: true
        onTriggered: {
            console.debug("Triggered")
            main.counter--;
            var id = devicesModel.model.get(idx[main.counter]).id
            var item = devicesModel.model.get(main.counter)
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
