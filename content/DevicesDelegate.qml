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

Item {
    id: container
    property real hm: 1.0
    property int appear: -1
    property real startRotation: 1

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false

    signal send()

    onAppearChanged: {
        container.startRotation = 0.5
        flipBar.animDuration = appear;
        delayedAnim.start();
    }

    SequentialAnimation {
        id: delayedAnim
        PauseAnimation { duration: 50 }
        ScriptAction { script: flipBar.flipDown(startRotation); }
    }

    width: parent.width
    height: flipBar.height * hm


    FlipBar {
        id: flipBar

        property bool flipped: false
        delta: startRotation

        anchors.bottom: parent.bottom
        width: container.GridView.view ? container.GridView.view.width : 0
        height: container.GridView.view ? container.GridView.view.height : 0

        front: Rectangle {
            width: container.GridView.view ? container.GridView.view.cellWidth : 0
            height: container.GridView.view ? container.GridView.view.cellHeight : 0
            border.color: "blue"
            border.width: 5

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    flipBar.flipUp()
                    flipBar.flipped = true
                }
            }

            Text {
                id: device
                text: model.sensor_id
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                x: 10; y: 9
                font.pointSize: 18
                font.bold: true
                color: "black"
            }
            Text {
                id: status
                text: model.state
                font.pointSize: 30
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
                        //main.reload()
                    }
                }
            }
        }

        back: Rectangle {
            id: power_command2
            width: container.ListView.view ? container.ListView.view.cellWidth : 0
            height: container.GridView.view ? container.GridView.view.cellHeight : 0
            color: "black"
            border.color: "white"
            border.width: 5

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    flipBar.flipDown()
                    flipBar.flipped = false
                }
            }

            Text {
                id: device2
                text: model.sensor_id
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                x: 10; y: 9
                font.pointSize: 18
                font.bold: true
                color: "black"
            }
            Text {
                id: status2
                text: model.state
                font.pointSize: 14
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: device2.bottom
                }
                color: "black"

                MouseArea{
                    id: send_command
                    width: parent.width
                    height: parent.height
                    onClicked: if (status2.text == qsTr("on")) {
                                   power_command("off")
                               }
                               else{
                                   power_command("on")
                               }
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
        var power_data = '{ "state" : "' + state + '", "sensor_id":"' + model.sensor_id + '", "kwh":12}';
        req.send(power_data);
    }
}
