// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Item {
    objectName: "SystemProfile"
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

            Image {
                Layout.alignment: Qt.AlignHCenter
                
                source: bridge.upowerProfile + ".svg"
                sourceSize.width: 64
                sourceSize.height: 64
            }

            Text {
                Layout.minimumHeight: 32
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: UI.Palette.base
                text: bridge.upowerProfile
            }
        }
    }
}
