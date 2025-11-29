// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Controls as QQC2

QQC2.Pane {
    id: main
    width: 512
    height: 512
    
    ListModel {
        id: winlist
        
        ListElement {
            name: "Dashboard"
            index: 0
        }
        
        ListElement {
            name: "Data"
            index: 1
        }
        
        ListElement {
            name: "Info"
            index: 2
        }
        
        ListElement {
            name: "Settings"
            index: 3
        }
    }
    
    ListView {
        id: menu
        model: winlist
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 128
        
        delegate: QQC2.Button {
            required property string name
            required property int index
            
            text: name
            
            onClicked: {
                console.log("Move to " + index);
                swipe.setCurrentIndex(index);
            }
        }
    }
    
    QQC2.SwipeView {
        id: swipe
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: menu.right
        anchors.right: parent.right
        
        currentIndex: 0
        orientation: Qt.Vertical
        interactive: true
        
        onCurrentIndexChanged: {
            console.log(currentIndex);
        }
        
        QQC2.Pane {
            id: dashboard
            //width: 128 * 5
            //height: 128 * 5
            //visible: false

            Component.onCompleted: {
                console.log("Available sensors:");
                for (var sensor in bridge.sensorList) {
                    console.log("+",bridge.sensorList[sensor]);
                }

                console.log(bridge.vendor);
                console.log(bridge.product);
                console.log(bridge.slimbookModel);
                console.log(bridge.slimbookFamily);

                for (var n=0;n<config.length;n++) {

                    var match = false;

                    switch (config[n].match.type) {
                        case "dmi":
                            var dmivendor = config[n].match.vendor;
                            var dmiproduct = config[n].match.product;
                            if (dmivendor.match(bridge.vendor) && dmiproduct.match(bridge.product)) {
                                match = true;
                            }
                        break;

                        case "family":
                            var family = config[n].match.family;

                            if (family.match(bridge.slimbookFamily)) {
                                match = true;
                            }
                        break;

                        case "model":
                            var model = config[n].match.model;

                            if (model == bridge.slimbookModel) {
                                match = true;
                            }
                        break;
                    }

                    console.log("* ",config[n].name," match:",match);

                    if (match == false) {
                        continue;
                    }

                    for (var i=0;i<config[n].layout.length;i++) {
                        var item = config[n].layout[i];

                        if (item.type == "Value") {
                            var component = Qt.createComponent("Value.qml");
                            var o = component.createObject(container,{
                                    sensor:item.sensor,
                                    label:item.label,
                                    unit:item.unit,
                                    warning: (item.warning === undefined) ? 100000.0 : item.warning,
                                    critical: (item.critical === undefined) ? 100000.0 : item.critical,
                            });

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }

                        if (item.type == "MultiValue") {
                            var component = Qt.createComponent("MultiValue.qml");
                            var o = component.createObject(container,{
                                sensor:item.sensor,
                                label:item.label,
                                unit:item.unit,
                                warning: (item.warning === undefined) ? 100000.0 : item.warning,
                                                           critical: (item.critical === undefined) ? 100000.0 : item.critical,
                            });

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }

                        if (item.type == "SystemProfile") {
                            var component = Qt.createComponent("SystemProfile.qml");
                            var o = component.createObject(container,{});

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }

                        if (item.type == "CpuInfo") {
                            var component = Qt.createComponent("CpuInfo.qml");
                            var o = component.createObject(container,{});

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }

                        if (item.type == "SlimbookProfile") {
                            var component = Qt.createComponent("SlimbookProfile.qml");
                            var o = component.createObject(container,{});

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }
                        
                        if (item.type == "TDP") {
                            var component = Qt.createComponent("TDP.qml");
                            var o = component.createObject(container,{});

                            o.Layout.row = item.row;
                            o.Layout.column = item.col;
                        }

                    }

                }

                console.log(bridge.getCPUName());
                console.log(bridge.getTDP());

            }

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered:{
                    bridge.updateSensors();
                }
            }

            ColumnLayout {
                anchors.fill:parent

                QQC2.Label {
                    Layout.alignment: Qt.AlignHCenter
                    height: 64

                    text: bridge.vendor + "/" + bridge.product
                }
                
                GridLayout {
                    id: container
                    columns: 4
                    rows: 4
                    Layout.alignment: Qt.AlignHCenter
                    
                }
                

            }
        }
        
        
        QQC2.Pane {
            id: rawdata
            //anchors.fill: parent
            //visible: false
            
            Text {
                text: "Raw data"
            }
            
        }
    }
}



