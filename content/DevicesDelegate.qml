/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Dialogs 1.2
import EnergyGraph 1.0

Item {
    id: container
    property real hm: 1.0
    property int appear: -1
    property real startRotation: 1

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false

    signal send()

    width: parent.width
    height: flipBar.height * hm

    MessageDialog {
        id: messageDialog
        onAccepted: visible = false
        Component.onCompleted: visible = false
    }

    Flipable {
        id: flipBar

        property bool flipped: false

        anchors.bottom: parent.bottom
        width: container.GridView.view.cellWidth
        height: container.GridView.view.cellHeight

        transform: Rotation {
            id: rotation
            origin.x: flipBar.width/2
            origin.y: flipBar.height/2
            axis.x: 0
            axis.y: 1
            axis.z: 0
            angle: 0
        }

        states: State {
            name: "BACK"
            PropertyChanges {
                target: rotation;
                angle: 180
            }
            when: flipBar.flipped
        }

        transitions: Transition {
            NumberAnimation {
                target: rotation
                property: "angle"
                duration: 500
            }
        }

        front: Rectangle {
            anchors.centerIn: parent
            anchors.fill: parent
            border.color: "#8b8989"
            border.width: 5

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked");
                    flipBar.flipped = !flipBar.flipped;
                }
            }

            Text {
                id: device
                text: model.sensor_id
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                x: 10; y: 9
                font.pointSize: 18
                font.family: "Arial"
                font.bold: true
                color: "black"
            }
            Text {
                id: status
                text: model.state
                font.pointSize: 30
                font.family: "Arial"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: device.bottom
                }
                MouseArea{
                    id: send_command2
                    anchors.fill: parent
                    onClicked: {
                        if (qsTr(status.text) == qsTr("on")) {
                            power_command("off")
                        }
                        else{
                            power_command("on")
                        }
                        container.send()
                    }
                }
            }
        }

        back: Rectangle {
            id: power_command2
            anchors.centerIn: parent
            anchors.fill: parent
            border.color: "#8b8989"
            border.width: 5
            Rectangle{
                anchors.centerIn: parent
                height: parent.height-10
                width: parent.width-10
                color: "transparent"
                EnergyGraph {
                    anchors.centerIn: parent
                    anchors.fill: parent
                    Component.onCompleted: {
                        initEnergyGraph(ip_addr, device.text);
                        setTime(6);
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    flipBar.flipDown()
                    flipBar.flipped = false
                }
            }
        }
    }
    function power_command(state) {
        var req = new XMLHttpRequest;
        req.open("PUT", ip_addr + "/sensors/" + model.sensor_id, true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        req.onreadystatechange = function() {
            if (req.readyState === req.DONE) {
                console.log("reloading after device on/off")
                try {
                    var object = JSON.parse(req.responseText);
                    if (state === "on") {
                        optimizationCheck(object);
                    }
                    console.log("finished");
                } catch (e) {
                    console.log(e + "Could not reach network");
                }
            }
        }

        var power_data = '{ "state" : "' + state + '", "sensor_id":"' + model.sensor_id + '", "kwh":12}';
        req.send(power_data);
        main.reload()
    }

    function optimizationCheck(obj) {
        var optimizationString;
        if (obj.optimizations.is_cheaper_at !== undefined) {
            if (obj.optimizations.is_cheaper_at.one_am !== undefined) {
                optimizationString = "You should run this at 1:00 am because it is" +
                        obj.optimizations.is_cheaper_at.one_am.by / obj.price_per_kwh + "%";
            } else {
                optimizationString = "You should run this at 10:00 am because it is" +
                        obj.optimizations.is_cheaper_at.ten_am.by / obj.price_per_kwh + "%";
            }
        } else {
            optimizationString = "There is no optimization to be made. Nice!"
        }
        messageDialog.title = "Optimizations";
        messageDialog.text = optimizationString;
        messageDialog.setVisible(true);
    }
}
