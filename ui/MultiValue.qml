// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Item {
    objectName: "MultiValue"

    property string sensor : ""
    property var values : ({})

    property string label: ""
    property string unit: ""
    property double warning: 100000.0
    property double critical: 100000.0
    property double minimum: 0
    property double maximum: 100000.0

    width: 128
    height: 128
    property int col : 0
    property int row : 0

    Connections {
        target: bridge

        function onSensorsUpdated()
        {
            for (var n in bridge.sensorList) {
                var src = bridge.sensorList[n];

                if (src.match(sensor)) {
                    values[src] = bridge.readSensor(src);
                }
            }

            canvas.requestPaint();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: UI.Palette.base
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill:parent
            
            Canvas {
                id: canvas
                //width: 120
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 4
                Layout.rightMargin: 4
                Layout.topMargin: 8
                //anchors.centerIn: parent
                Layout.alignment: Qt.AlignHCenter

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0,0,width,height);
                    //ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
                    //ctx.fillRect(0, 0, width, height);

                    var blockWidth = width / Object.keys(values).length;
                    //console.log(blockWidth);

                    var xpos = 0;
                    var range = maximum - minimum;
                    
                    ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
                    for (var src in values) {

                        ctx.fillStyle = UI.Palette.base;
                        var raw = values[src];
                        
                        var value = (raw - minimum) / range;
                        if (value < 0) {
                            value = 0;
                        }
                        
                        if (value > 1.0) {
                            value = 1.0;
                        }
                        
                        if (raw < warning) {
                            ctx.fillStyle = UI.Palette.base;
                        }
                        else {
                            if (raw < critical) {
                                ctx.fillStyle = UI.Palette.warning;
                            }
                            else {
                                ctx.fillStyle = UI.Palette.critical;
                            }
                        }
                        
                        //console.log("mv ",src," ",value);

                        ctx.fillRect(xpos, height - (value*height), blockWidth, height);

                        xpos = xpos + blockWidth;
                    }
                    
                    ctx.strokeStyle = UI.Palette.base;
                    ctx.beginPath();
                    ctx.moveTo(0,height);
                    ctx.lineTo(width,height);
                    ctx.stroke();
                    ctx.closePath();
                }
            }
            
            Text {
                Layout.minimumHeight: 32
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: UI.Palette.base
                text: label
            }
        }
    }
}
