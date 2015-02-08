import QtQuick 2.0

Rectangle {
    color: "#d6d6d6"
    width: parent.width
    height: childrenRect.height
    z: 2
    Connections {
        target: mainListView
        onAutoSearch: {
            if (type == 'tag') {
                tagSearch.open()
                tagSearch.searchText = str
            } else if (type == 'user'){
                userSearch.open()
                userSearch.searchText = str
            } else {
                wordSearch.open()
                wordSearch.searchText = str
            }
        }
    }

    Column {
        width: parent.width

        Text {
            text: "List of Devices"
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        Component.onCompleted: {
            mainListView.positionViewAtBeginning()
            mainListView.clear()
            devicesModel.from = ""
            devicesModel.phrase = searchText
        }
    }
}
