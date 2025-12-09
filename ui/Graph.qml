// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Canvas {
    id: root
    
    property int points: 32
    property var data: ([])
    property double pmin: 0.0
    property double pmax: 0.0
    
    function push(value) {
        data.push(value);
        
        if (data.length >= points) {
            data.shift();
        }
        
        root.requestPaint();
    }
    
    Component.onCompleted: {
        for (var n=0;n<points;n++) {
            data.push(0.0);
        }
    }
    
    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0,0,width,height);
        
        for (var n=0;n < points;n++) {
            if (data[n] > pmax) {
                pmax = data[n];
            }
            
            if (data[n] < pmin) {
                pmin = data[n];
            }
        }
        
        var pw = width/(points - 1);
        var pos = 0;
        var range = pmax - pmin;
        
        ctx.strokeStyle = UI.Palette.base;
        ctx.strokeRect(0,0,width,height);
        
        var value = data[0]/range;
        
        ctx.beginPath();
        ctx.moveTo(pos,height - (value * height));
        pos = pos + pw;
        
        for (var n=1;n < points; n++) {
            var value = data[n]/range;
            
            ctx.lineTo(pos,height - (value * height));
            
            //ctx.moveTo(pos,0);
            //ctx.lineTo(pos,height);
            
            ctx.moveTo(pos,height - (value * height));
            pos = pos + pw;
        }
        
        ctx.closePath();
        ctx.stroke();
    }

}
