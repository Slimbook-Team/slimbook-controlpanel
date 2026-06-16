// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef SLIMBOOK_CONTROLPANEL_CLIENT
#define SLIMBOOK_CONTROLPANEL_CLIENT

#include <QQuickView>
#include <QObject>

namespace slimbook
{
    namespace controlpanel
    {
        class ClientService : public QObject
        {
            Q_OBJECT
            Q_CLASSINFO("D-Bus Interface", "com.slimbook.controlpanel")

            QQuickView* m_view;

            public:

            explicit ClientService(QObject *parent = nullptr);
            virtual ~ClientService();

            void setView(QQuickView* view);

            public slots:

            void show();
        };
    }
}

#endif
