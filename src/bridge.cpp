// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "bridge.hpp"
#include "common.hpp"

#include <slimbook.h>

#include <QString>
#include <QDBusMessage>
#include <QDBusReply>
#include <QList>
#include <QVariant>
#include <QJsonDocument>
#include <QFile>
#include <QDir>
#include <QDebug>

#include <iostream>

using namespace slimbook::controlpanel;
using namespace std;

Bridge::Bridge(QObject *parent): QObject{parent}
{

    m_vendor = QString::fromStdString(slb_info_board_vendor());
    m_product = QString::fromStdString(slb_info_product_name());

    m_slimbookModel = slb_info_get_model();
    m_slimbookFamily = slb_info_get_family_name();

    QDBusConnection bus =  QDBusConnection::systemBus();
    cpIface = new QDBusInterface("com.slimbook.controlpanel","/controlpanel","com.slimbook.controlpanel",bus);

    if (!cpIface->isValid()) {
        qCritical() << "Failed to create DBus interface."
        << "Bus error:" << bus.lastError().message();
    }
    else {
        
        QList<QVariant> reply = cpIface->call("getSensorList").arguments();
        
        if (reply.count() > 0) {
            m_sensors = reply.at(0).toStringList();
            for (QString& sensor:m_sensors) {
                cout<<"* "<<sensor.toStdString()<<endl;
            }
        }

    }

    upowerIface = new QDBusInterface("org.freedesktop.UPower.PowerProfiles","/org/freedesktop/UPower/PowerProfiles","org.freedesktop.UPower.PowerProfiles",bus);

    if (!upowerIface->isValid()) {
        qCritical() << "Failed to create DBus interface."
        << "Bus error:" << bus.lastError().message();
    }
    else {
        clog<<"current profile:"<<upowerIface->property("ActiveProfile").toString().toStdString()<<endl;

        m_upowerProfile = upowerIface->property("ActiveProfile").toString();
        emit upowerProfileChanged();

        bus.connect(
            "org.freedesktop.UPower.PowerProfiles",
            "/org/freedesktop/UPower/PowerProfiles",
            "org.freedesktop.DBus.Properties",
            "PropertiesChanged",
            this,
            SLOT(onUpowerPropertiesChanged(QString,QVariantMap,QStringList)) );

    }

}

QVariant Bridge::loadConfig()
{
    QFile configFile;

    configFile.setFileName(QDir::home().path()+".config/slimbook-controlpanel.json");

    if (!configFile.exists()) {
        return QVariant();
    }

    QJsonDocument config = QJsonDocument::fromJson(configFile.readAll());

    return config.toVariant();
}

void Bridge::saveConfig(QVariant config)
{
    //TODO
}

QVariant Bridge::loadDefaults()
{
    QFile configFile;

    configFile.setFileName(":/default.json");
    configFile.open(QIODevice::ReadOnly);

    QJsonDocument config = QJsonDocument::fromJson(configFile.readAll());

    return config.toVariant();
}

void Bridge::updateSensors()
{

    cpIface->call("updateSensors");
    emit sensorsUpdated();
}

double Bridge::readSensor(QString sensor)
{
    double value = 0;
    
    QList<QVariant> reply = cpIface->call("readSensor",sensor).arguments();
    if (reply.count() > 0) {
        value = reply.at(0).toDouble();
    }
    return value;
}

QString Bridge::getSensorLabel(QString sensor)
{
    QString value;
    
    QList<QVariant> reply = cpIface->call("getSensorLabel",sensor).arguments();
    if (reply.count() > 0) {
        value = reply.at(0).toString();
    }
    return value;
}

QString Bridge::getCPUName()
{
    QString value;

    QList<QVariant> reply = cpIface->call("getCPUName").arguments();

    if (reply.count() > 0) {
        value = reply.at(0).toString();
        qDebug()<<reply.at(0);
    }

    return value;
}

QString Bridge::getQC71Profile()
{
    QString value;

    QList<QVariant> reply = cpIface->call("getQC71Profile").arguments();

    if (reply.count() > 0) {
        value = reply.at(0).toString();
        qDebug()<<reply.at(0);
    }

    return value;
}

QVariantList Bridge::getTDP()
{
    QDBusReply<QVariantList> reply = cpIface->call("getTDP");

    if (reply.isValid()) {
        return reply.value();
    }
    else {
        QVariantList tmp;

        return tmp;
    }
}

void Bridge::onUpowerPropertiesChanged(const QString &interfaceName,
                         const QVariantMap &changedProperties,
                         const QStringList &invalidatedProperties)
{
    for (auto k = changedProperties.begin(); k!=changedProperties.end();k++) {
        if (k.key() == "ActiveProfile") {
            clog<<"ActiveProfile has changed:"<<k.value().toString().toStdString()<<endl;

            m_upowerProfile = k.value().toString();
            emit upowerProfileChanged();
        }
    }
}
