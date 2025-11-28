// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Item {
    objectName: "SlimbookProfile"
    width: 128
    height: 128
    property int col : 0
    property int row : 0

    Connections {
        target: bridge

        function onUpowerProfileChanged()
        {
            profile.text = bridge.getQC71Profile();
            qc71Timer.start();
        }
    }
    
    Timer {
        id: qc71Timer
        repeat: false
        running: false
        interval: 1000
        
        onTriggered: {
            profile.text = bridge.getQC71Profile();
        }
    }
    
    Component.onCompleted: {
        profile.text = bridge.getQC71Profile();
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: UI.Palette.base
        border.width: 2
        radius: 8

        ColumnLayout {
            anchors.fill:parent

            Image {
                id: icon
                Layout.alignment: Qt.AlignHCenter
                
                source: "slimbook-cpu.svg"
                sourceSize.width: 64
                sourceSize.height: 64
                
            }
                   
            Text {
                id: profile
                Layout.minimumHeight: 32
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: UI.Palette.base
                text: ""
            }
        }
    }
}
