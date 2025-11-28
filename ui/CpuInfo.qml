// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Item {
    objectName: "CpuInfo"
    width: 128
    height: 128
    property int col : 0
    property int row : 0
    
    property string cpuName: ""
    property string cpuVendor: ""
    
    Component.onCompleted: {
        cpuName = bridge.getCPUName();
        
        if (cpuName.indexOf("AMD") !=-1) {
            cpuVendor = "AMD";
        }
        else {
            cpuVendor = "Intel";
        }
        
        console.log(cpuVendor);
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
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.maximumWidth: 120
                color: UI.Palette.base
                text: cpuName
                wrapMode: Text.WordWrap
            }

        }
    }
}
