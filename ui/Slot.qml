// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

Item {
    id: root

    objectName: "Slot"
    width: 128
    height: 128

    property int col : 0
    property int row : 0

    MouseArea {
        anchors.fill:root
        drag.target: root
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        drag.onActiveChanged:{
            if (drag.active) {

            }
            else {
                //console.log("dropped at "+sensorSlot.x+","+sensorSlot.y);
                root.parent.recompute(root);
            }
        }

        onClicked: (mouse) => {
            if (mouse.button == Qt.RightButton) {
                root.parent.menu(root,mouse.x,mouse.y);
            }
        }
    }
}
