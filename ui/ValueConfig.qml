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

    GridLayout {
        QQC2.Label {
            Layout.row: 0
            Layout.column: 0

            text: "Label"
        }

        QQC2.TextField {
            Layout.row: 0
            Layout.column: 1

            text: config.target.label
        }

        QQC2.Label {
            Layout.row: 1
            Layout.column: 0

            text: "Unit"
        }

        QQC2.TextField {
            Layout.row: 1
            Layout.column: 1

            text: config.target.unit
        }

        QQC2.Label {
            Layout.row: 2
            Layout.column: 0

            text: "Sensor"
        }

        QQC2.TextField {
            Layout.row: 2
            Layout.column: 1

            text: config.target.sensor
        }

        QQC2.Label {
            Layout.row: 3
            Layout.column: 0

            text: "Warning"
        }

        QQC2.TextField {
            Layout.row: 3
            Layout.column: 1

            text: config.target.warning
        }

        QQC2.Label {
            Layout.row: 4
            Layout.column: 0

            text: "Critical"
        }

        QQC2.TextField {
            Layout.row: 4
            Layout.column: 1

            text: config.target.critical
        }

        QQC2.Label {
            Layout.row: 5
            Layout.column: 0

            text: "Minimum"
        }

        QQC2.TextField {
            Layout.row: 5
            Layout.column: 1

            text: config.target.minimum
        }

        QQC2.Label {
            Layout.row: 6
            Layout.column: 0

            text: "Maximum"
        }

        QQC2.TextField {
            Layout.row: 6
            Layout.column: 1

            text: config.target.maximum

            validator: DoubleValidator {
                decimals: 4
                notation: DoubleValidator.StandardNotation
            }
        }
    }
}
