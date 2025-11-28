// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef SLIMBOOK_CONTROLPANEL_BRIDGE
#define SLIMBOOK_CONTROLPANEL_BRIDGE

#include <QObject>
#include <QStringList>
#include <QDBusConnection>
#include <QDBusInterface>

#include <vector>
#include <map>

namespace slimbook
{
    namespace controlpanel
    {

        class Bridge: public QObject
        {
            Q_OBJECT

            Q_PROPERTY(QStringList sensorList MEMBER m_sensors CONSTANT)
            Q_PROPERTY(QString upowerProfile MEMBER m_upowerProfile NOTIFY upowerProfileChanged)

            Q_PROPERTY(QString vendor MEMBER m_vendor CONSTANT)
            Q_PROPERTY(QString product MEMBER m_product CONSTANT)
            Q_PROPERTY(uint32_t slimbookModel MEMBER m_slimbookModel CONSTANT)
            Q_PROPERTY(QString slimbookFamily MEMBER m_slimbookFamily CONSTANT)

        public:

            QStringList m_sensors;
            QString m_upowerProfile;

            QString m_vendor;
            QString m_product;
            uint32_t m_slimbookModel;
            QString m_slimbookFamily;

            Bridge(QObject *parent = nullptr);

            Q_INVOKABLE void updateSensors();
            Q_INVOKABLE double readSensor(QString sensor);
            Q_INVOKABLE QString getCPUName();
            Q_INVOKABLE QString getQC71Profile();
            Q_INVOKABLE QVariantList getTDP();

            Q_SIGNALS:

            void sensorsUpdated();
            void upowerProfileChanged();

            public Q_SLOTS:

            void onUpowerPropertiesChanged(const QString &interfaceName,
                                     const QVariantMap &changedProperties,
                                     const QStringList &invalidatedProperties);

        private:
            
            QDBusInterface* cpIface;
            QDBusInterface* upowerIface;
        };
    }
}

#endif
