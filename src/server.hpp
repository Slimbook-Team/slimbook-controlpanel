// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef SLIMBOOK_CONTROLPANEL_SERVER
#define SLIMBOOK_CONTROLPANEL_SERVER

#include "sensors.hpp"

#include <QDBusAbstractAdaptor>
#include <QObject>
#include <QStringList>
#include <QVariantList>

#include <map>
#include <vector>
#include <string>

namespace slimbook
{
    namespace controlpanel
    {
        class Server : public QObject
        {
            Q_OBJECT

        public:

            explicit Server(QObject *parent = nullptr);
            virtual ~Server();

        public slots:

            QStringList getSensorList();

            void updateSensors();

            double readSensor(QString sensor);
            
            QString getSensorLabel(QString sensor);

            QString getCPUName();

            QString getQC71Profile();

            QVariantList getTDP();

        private:

            std::vector<Sensor*> inputs;
            std::map<std::string,Node*> nodes;
            QStringList m_sensors;
            QString m_cpuName;

        };

        class ServerAdaptor : public QDBusAbstractAdaptor
        {
            Q_OBJECT
            Q_CLASSINFO("D-Bus Interface", "com.slimbook.controlpanel")

        public:

            explicit ServerAdaptor(Server* parent = nullptr);

        public slots:

            QStringList getSensorList();

            void updateSensors();

            double readSensor(QString sensor);
            
            QString getSensorLabel(QString sensor);

            QString getCPUName();

            QString getQC71Profile();

            QVariantList getTDP();

        private:

            Server* m_server;

        };
    }
}
#endif
