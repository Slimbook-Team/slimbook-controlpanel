// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import "." as UI

import QtQuick
import QtQuick.Layouts

Canvas {
    id: root
    
    property double minimum: -Infinity
    property double maximum: Infinity

    property int points: 32
    property var data: ([])
    
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
        var dynamicRange = true;

        ctx.clearRect(0,0,width,height);
        var pmin = 0.0;
        var pmax = 0.0;

        if (minimum !== -Infinity && maximum !== Infinity) {
            pmin = minimum;
            pmax = maximum;

            dynamicRange = false;
        }
        else {
            for (var n=0;n < points;n++) {
                if (data[n] > pmax) {
                    pmax = data[n];
                }

                if (data[n] < pmin) {
                    pmin = data[n];
                }
            }
        }
        
        var pw = width/(points - 1);
        var pos = 0;
        var range = pmax - pmin;
        
        for (var n=0;n<points;n++) {
            var raw = data[n];
            var value = raw/range;
            
            if (value < 0) {
                value = 0;
            }

            ctx.fillStyle = UI.Palette.base;

            if (value >= 0.99) {

                if (dynamicRange == false) {
                    ctx.fillStyle = UI.Palette.maximum;
                }
            }

            if (value > 1.0) {
                value = 1.0;

                if (dynamicRange == false) {
                    ctx.fillStyle = UI.Palette.saturation;
                }
            }

            if (raw > warning) {
                ctx.fillStyle = UI.Palette.warning;
            }

            if (raw > critical) {
                ctx.fillStyle = UI.Palette.critical;
            }
            
            ctx.fillRect(pos-(pw/2),height-(value*height),pw,height);
            
            pos = pos + pw;
        }
        
        ctx.strokeStyle = UI.Palette.base;
        ctx.beginPath();
        
        ctx.moveTo(0,0);
        ctx.lineTo(width,0);
        
        ctx.moveTo(0,height);
        ctx.lineTo(width,height);
        
        ctx.moveTo(0,height/2);
        ctx.lineTo(width,height/2);
        
        ctx.closePath();
        ctx.stroke();
        
    }

}
