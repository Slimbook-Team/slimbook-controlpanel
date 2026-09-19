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

    onSave: {
        config.target.label = txtLabel.text;
        config.target.unit = txtUnit.text;
    }

    ListModel {
        id: tableModel
    }

    GridLayout {
        QQC2.Label {
            Layout.row: 0
            Layout.column: 0

            text: "Label"
        }

        QQC2.TextField {
            id: txtLabel
            Layout.row: 0
            Layout.column: 1

            text: config.target.label

            onTextEdited: {
                config.changes();
            }
        }

        QQC2.Label {
            Layout.row: 1
            Layout.column: 0

            text: "Unit"
        }

        QQC2.TextField {
            id: txtUnit
            Layout.row: 1
            Layout.column: 1

            text: config.target.unit

            onTextEdited: {
                config.changes();
            }
        }

        QQC2.Label {
            Layout.row: 2
            Layout.column: 0

            text: "Sensor"
        }

        QQC2.ComboBox {
            id: cmbSensor
            Layout.row: 2
            Layout.column: 1

            model: tableModel
            textRole: "label"

            Component.onCompleted: {
                for (var item in bridge.sensorList) {
                    var sensorName = bridge.sensorList[item];
                    var sensorLabel = bridge.getSensorLabel(sensorName);

                    tableModel.append(
                        {
                            sensor: (sensorLabel.length > 0) ? "label:" + sensorLabel : sensorName,
                            label: (sensorLabel.length > 0) ? sensorLabel : sensorName
                        });
                }

                /* this has some room for improvement */
                cmbSensor.displayText = config.target.sensor.replace("label:","");
            }

            onActivated: {
                config.changes();
            }
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

            onTextEdited: {
                config.changes();
            }

            validator: DoubleValidator {
                decimals: 4
                notation: DoubleValidator.StandardNotation
            }
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

            onTextEdited: {
                config.changes();
            }

            validator: DoubleValidator {
                decimals: 4
                notation: DoubleValidator.StandardNotation
            }
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

            onTextEdited: {
                config.changes();
            }

            validator: DoubleValidator {
                decimals: 4
                notation: DoubleValidator.StandardNotation
            }
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

            onTextEdited: {
                config.changes();
            }

            validator: DoubleValidator {
                decimals: 4
                notation: DoubleValidator.StandardNotation
            }
        }
    }
}
