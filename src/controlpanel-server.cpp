// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "common.hpp"
#include "server.hpp"

#include <QCoreApplication>
#include <QDBusConnection>

#include <iostream>
#include <fstream>
#include <string>

using namespace slimbook::controlpanel;
using namespace std;

int main(int argc,char * argv[])
{

    QCoreApplication app(argc, argv);

    Server server(&app);
    ServerAdaptor adaptor(&server);
    
    auto connection = QDBusConnection::systemBus();

    if (!connection.isConnected()) {
        cerr<<"could not connect to d-bus"<<endl;
    }

    if (!connection.registerService("com.slimbook.controlpanel")) {
        cerr<<"could not register service!"<<endl;
    }

    if (!connection.registerObject("/controlpanel", &server, QDBusConnection::ExportAdaptors |QDBusConnection::ExportAllSlots | QDBusConnection::ExportAllSignals)) {
        cerr<<"could not register object!"<<endl;
    }
    
    return app.exec();

}
