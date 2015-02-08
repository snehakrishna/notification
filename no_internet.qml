import QtQuick 2.0

Rectangle {
    width: width
    height: height
    color: "white"

    Text {
        id: title
        color: "black"
        font.pixelSize: parent.width / 15
        wrapMode: Text.Wrap
        text: "You are not connected to the internet. \nYou cannot see any information about your devices at this time."
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }
}
