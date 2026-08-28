// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2026 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Slot {
    objectName: "Badge"

    property string source: "../images/badges/stripes.svg"
    
    onClicked: {
        var badges = ["stripes","boou","tux"];
        
        if (source.startsWith("../images/badges/")) {
            var n = source.lastIndexOf("/");
            var name = source.substring(n+1);
            n = name.lastIndexOf(".");
            name = name.substring(0,n);
            n = badges.indexOf(name);
            n = n + 1;
            n = n % badges.length;
            
            source = "../images/badges/" + badges[n] + ".svg";
        }
    }
    
    Image {
        anchors.fill: parent
        source: parent.source
        sourceSize.width: 128
        sourceSize.height: 128
    }
}
