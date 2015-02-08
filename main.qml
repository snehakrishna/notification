import QtQuick 2.0
import "content"

Rectangle {
    id: main
    width: width
    height: height
    color: "white"

    property int inAnimDur: 250
    property int counter: 0
    property alias isLoading: tweetsModel.isLoading
    property var idx
    property var ids

    Component.onCompleted: ids = new Array()

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
            mainListView.add( { "statusText": Helper.insertLinks(item.text, item.entities),
                                "twitterName": item.user.screen_name,
                                "device" : item.user.name,
                                "userImage": item.user.profile_image_url,
                                "source": item.source,
                                "id": id,
                                 "uri": Helper.insertLinks(item.user.url, item.user.entities),
                                "published": item.created_at } );
            ids.push(id)
        }
    }

    GridView {
        id: mainListView
        anchors.fill: parent
        delegate: DevicesDelegate { }
        model: ListModel { id: finalModel }
        cellWidth: parent.width / 3
        cellHeight: mainListView.cellWidth

        add: Transition {
            NumberAnimation { property: "hm"; from: 0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
            PropertyAction { property: "appear"; value: 250 }
        }

        onDragEnded: if (header.refresh) { devicesModel.reload() }

        ListHeader {
            id: header
            y: -mainListView.contentY - height
        }

//        footer: ListFooter { }

        function clear() {
            ids = new Array()
            model.clear()
        }

        function add(obj) {
            model.insert(0, obj)
        }

//        signal autoSearch(string type, string str) // To communicate with Footer instance
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
