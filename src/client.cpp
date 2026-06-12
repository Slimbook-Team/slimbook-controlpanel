// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "client.hpp"
#include "common.hpp"

#include <QDebug>

using namespace slimbook::controlpanel;
using namespace std;

ClientService::ClientService(QObject *parent) : QObject(parent), m_view(nullptr)
{
}

ClientService:: ~ClientService()
{
}

void ClientService::setView(QQuickView* view)
{
    m_view = view;
}

void ClientService::show()
{
    if (m_view) {
        m_view->show();
    }
}
