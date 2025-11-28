// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "common.hpp"
#include "bridge.hpp"

#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QQuickItem>
#include <QVariant>
#include <QJsonDocument>
#include <QFile>
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

int main(int argc,char*argv[])
{

    QApplication app(argc,argv);

    Bridge* bridge = new Bridge();

    QFile configFile;

    configFile.setFileName(":/default.json");
    configFile.open(QIODevice::ReadOnly);

    QJsonDocument config =QJsonDocument::fromJson(configFile.readAll());
    qDebug()<<config;

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    QQmlContext* ctxt = view.rootContext();
    ctxt->setContextProperty(QStringLiteral("config"), config.toVariant());
    ctxt->setContextProperty(QStringLiteral("bridge"), bridge);

    view.setSource(QUrl("qrc:/ui/main.qml"));
    view.show();

    app.exec();

    return 0;
}
