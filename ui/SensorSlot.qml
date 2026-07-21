// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

Item {
    id: sensorSlot
    objectName: "sensorSlot"

    property string sensor : ""
    property double value : 0.0
    
    signal updated();

    Connections {
        target: bridge

        function onSensorsUpdated()
        {
            sensorSlot.value = bridge.readSensor(sensorSlot.sensor);
            updated();
        }
    }

    MouseArea {
        anchors.fill:sensorSlot
        drag.target: sensorSlot

        drag.onActiveChanged:{
            if (drag.active) {

            }
            else {
                //console.log("dropped at "+sensorSlot.x+","+sensorSlot.y);
                sensorSlot.parent.recompute(sensorSlot);
            }
        }
    }

}

