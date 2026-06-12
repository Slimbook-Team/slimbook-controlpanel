// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "common.hpp"
#include "client.hpp"
#include "bridge.hpp"

#include <QApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QVariant>
#include <QFile>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusMessage>
#include <QDBusObjectPath>
#include <QDBusVariant>
#include <QDebug>

#include <iostream>
#include <chrono>
#include <thread>
#include <fstream>
#include <cstdint>
#include <string>
#include <filesystem>
#include <vector>
#include <map>
#include <regex>

using namespace slimbook::controlpanel;
using namespace std;

bool is_alive()
{
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusInterface interface("com.slimbook.controlpanel", "/controlpanel", "org.freedesktop.DBus.Introspectable", connection);

    return interface.isValid();
}

void show()
{
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage msg;
    QDBusMessage reply;

    msg = QDBusMessage::createMethodCall("com.slimbook.controlpanel",
                                         "/controlpanel",
                                         "com.slimbook.controlpanel",
                                         "show");
    reply = connection.call(msg);
}

int main(int argc,char*argv[])
{

    QApplication::setQuitOnLastWindowClosed(false);
    QApplication app(argc,argv);

    if (is_alive()) {
        show();

        return 0;
    }

    Bridge* bridge = new Bridge();

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    app.connect(view.engine(), &QQmlEngine::quit, [=] {
            QApplication::quit();
        }
    );

    QQmlContext* ctxt = view.rootContext();
    ctxt->setContextProperty(QStringLiteral("bridge"), bridge);
    ctxt->setContextProperty(QStringLiteral("view"), &view);

    view.setSource(QUrl("qrc:/ui/main.qml"));
    view.show();

    QDBusConnection sessionBus = QDBusConnection::sessionBus();

    if (!sessionBus.registerService("com.slimbook.controlpanel")) {
        qDebug() << "Failed to register service:" << sessionBus.lastError().message();
        return 1;
    }

    ClientService service;
    service.setView(&view);

    if (!sessionBus.registerObject("/controlpanel", &service, QDBusConnection::ExportAllSlots)) {
        qDebug() << "Failed to register object:" << sessionBus.lastError().message();
        return 1;
    }

    qInfo()<<"running app";

    app.exec();

    return 0;
}
