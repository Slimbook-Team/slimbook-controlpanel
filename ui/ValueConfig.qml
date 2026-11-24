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
        config.target.sensor = cmbSensor.currentSensor;
        config.target.minimum = parseFloat(txtMinimum.text);
        config.target.maximum = parseFloat(txtMaximum.text);
        config.target.warning = parseFloat(txtWarning.text);
        config.target.critical = parseFloat(txtCritical.text);
    }

    ListModel {
        id: tableModel
    }

    GridLayout {
        anchors.fill: parent

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
            property string currentSensor: ""

            model: tableModel
            textRole: "label"

            Component.onCompleted: {
                var index = 0;

                for (var item in bridge.sensorList) {
                    var sensorName = bridge.sensorList[item];
                    var sensorLabel = bridge.getSensorLabel(sensorName);

                    var first = (sensorLabel.length > 0) ? "label:" + sensorLabel : sensorName;
                    var second = (sensorLabel.length > 0) ? sensorLabel : sensorName;

                    tableModel.append(
                        {
                            sensor: first,
                            label: second
                        });

                    if (config.target.sensor == first) {
                        console.log("found initial match");
                        cmbSensor.currentIndex = index;
                    }

                    index = index + 1;
                }

            }

            onActivated: {
                cmbSensor.currentSensor = cmbSensor.model.get(currentIndex).sensor;
                console.log(cmbSensor.currentSensor);
                config.changes();
            }
        }

        QQC2.Label {
            Layout.row: 3
            Layout.column: 0

            text: "Warning"
        }

        QQC2.TextField {
            id: txtWarning
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
            id: txtCritical
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
            id: txtMinimum
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
            id: txtMaximum
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
