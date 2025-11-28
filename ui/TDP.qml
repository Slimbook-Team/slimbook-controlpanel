// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Item {
    objectName: "TDP"
    width: 128
    height: 128
    property int col : 0
    property int row : 0
    
    property double stapm: 0.0
    
    Component.onCompleted: {
        var tmp = bridge.getTDP();
        stapm = tmp[1];
    }
    
    Connections {
        target: bridge

        function onSensorsUpdated()
        {
            var tmp = bridge.getTDP();
            stapm = tmp[1];
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

            Text {
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 26
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.maximumWidth: 120
                color: UI.Palette.base
                text: stapm.toFixed(2) + " W"
                wrapMode: Text.WordWrap
            }
            
            Text {
                Layout.minimumHeight: 32
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: UI.Palette.base
                text: "TDP"
            }

        }
    }
}
