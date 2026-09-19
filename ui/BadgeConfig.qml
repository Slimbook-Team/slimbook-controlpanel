// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2026 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Item {
    id: config
    property var target: undefined
    anchors.fill: parent

    Image {
        anchors.fill: parent
        source: target.source
        sourceSize.width: 128
        sourceSize.height: 128
    }

}
