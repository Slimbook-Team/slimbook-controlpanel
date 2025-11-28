// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

SensorSlot {
    objectName: "Value"
    property string label: ""
    property string unit: ""
    property double warning: 100000.0
    property double critical: 100000.0

    width: 128
    height: 128
    property int col : 0
    property int row : 0

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
                Layout.fillHeight: true
                font.pixelSize: 26
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: (value < warning) ? UI.Palette.base : ((value < critical) ? UI.Palette.warning : UI.Palette.critical)
                text: (unit!="") ? value.toFixed(2) + " "+unit : value.toFixed(2)
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
