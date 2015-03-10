import QtQuick 2.0

Item{
    id: button
    width: parent.width
    height: children.height
    property string boxText: ""


    Rectangle{
        width: parent.width
        height: box.height + 15
        border.color: "black"
        border.width: 5

        Text{
            id: box
            width: parent.width
            font.pointSize: 20
            text: boxText
        }

        MouseArea{
            id: mouse
            anchors.fill: parent
            onClicked:{}
        }
    }
}

