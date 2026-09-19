// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2026 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

UI.SlotConfig {
    id: config
    anchors.fill: parent

    ColumnLayout {
        anchors.centerIn: config

        Image {
            id: image
            width: 128
            height: 128

            source: target.source
            sourceSize.width: 128
            sourceSize.height: 128
        }

        QQC2.ComboBox {
            model: ["stripes","panel","panel-nostep","boou","boou-jp","tux"]

            onActivated: {
                image.source = "../images/badges/" + currentValue + ".svg";
            }
        }
    }
}
