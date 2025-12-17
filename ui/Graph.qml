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
        ctx.clearRect(0,0,width,height);
        var pmin = 0.0;
        var pmax = 0.0;

        if (minimum !== -Infinity && maximum !== Infinity) {
            pmin = minimum;
            pmax = maximum;
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
        
        var saturation = false;
        
        for (var n=0;n<points;n++) {
            var raw = data[n];
            var value = raw/range;
            
            if (raw < warning) {
                ctx.fillStyle = UI.Palette.base;
            }
            else {
                if (raw < critical) {
                    ctx.fillStyle = UI.Palette.warning;
                }
                else {
                    ctx.fillStyle = UI.Palette.critical;
                }
            }
            
            if (value < 0) {
                value = 0;
            }
            
            if (value > 1.0) {
                value = 1.0;
                saturation = true;
            }
            
            ctx.fillRect(pos-(pw/2),height-(value*height),pw,height);
            
            pos = pos + pw;
        }
        
        ctx.strokeStyle = UI.Palette.base;
        ctx.beginPath();
        if (saturation) {
            ctx.strokeStyle = UI.Palette.critical;
        }
        
        ctx.moveTo(0,0);
        ctx.lineTo(width,0);
        
        ctx.strokeStyle = UI.Palette.base;
        ctx.moveTo(0,height);
        ctx.lineTo(width,height);
        
        ctx.moveTo(0,height/2);
        ctx.lineTo(width,height/2);
        
        ctx.closePath();
        ctx.stroke();
        
        /*
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
        
        */
    }

}
