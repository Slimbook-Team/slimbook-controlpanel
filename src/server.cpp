// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "server.hpp"
#include "sensors.hpp"
#include "common.hpp"

#include <slimbook.h>

#include <QDBusConnection>

#include <iostream>

using namespace slimbook::controlpanel;
using namespace std;

ServerAdaptor::ServerAdaptor(Server* parent) : QDBusAbstractAdaptor(parent), m_server(parent)
{
    setAutoRelaySignals(true);
}

QStringList ServerAdaptor::getSensorList()
{
    return m_server->getSensorList();
}

void ServerAdaptor::updateSensors()
{
    m_server->updateSensors();
}

double ServerAdaptor::readSensor(QString sensor)
{
    return m_server->readSensor(sensor);
}

QString ServerAdaptor::getSensorLabel(QString sensor)
{
    return m_server->getSensorLabel(sensor);
}

QString ServerAdaptor::getCPUName()
{
    return m_server->getCPUName();
}

QString ServerAdaptor::getQC71Profile()
{
    return m_server->getQC71Profile();
}

QVariantList ServerAdaptor::getTDP()
{
    return m_server->getTDP();
}

Server::Server(QObject *parent) : QObject{parent}
{
    stringstream out;

    if(get_process_output("slimbookctl",{"info"},out) == 0) {
        string line;

        while (!out.eof()) {
            std::getline(out,line);
            vector<string> tmp = split(line,':');

            if (tmp.size()>1 and tmp[0] == "cpu") {
                m_cpuName = QString::fromStdString(tmp[1]);
            }
        }

    }

    inputs.push_back(new FrequencySensor());
    inputs.push_back(new HwmonTempSensor());
    inputs.push_back(new HwmonVoltageSensor());
    inputs.push_back(new HwmonPowerSensor());
    inputs.push_back(new HwmonFanSensor());
    inputs.push_back(new RaplSensor());
    inputs.push_back(new CpuLoadSensor());
    inputs.push_back(new RamSensor());
    inputs.push_back(new BatterySensor());

    for (Sensor* sensor : inputs) {

        for (Node& node:sensor->nodes()) {
            std::string path = sensor->name+"."+node.name;

            nodes[path] = &node;
            m_sensors<<QString::fromStdString(path);
        }
    }


}

Server::~Server()
{
}

QStringList Server::getSensorList()
{
    return m_sensors;
}

void Server::updateSensors()
{
    for (Sensor* sensor : inputs) {
        sensor->update();
    }
}

double Server::readSensor(QString sensor)
{
    string path = sensor.toStdString();

    if (nodes.find(path) != nodes.end()) {
        return nodes[path]->value;
    }

    return 0.0;
}

QString Server::getSensorLabel(QString sensor)
{
    string path = sensor.toStdString();

    if (nodes.find(path) != nodes.end()) {
        return QString::fromStdString(nodes[path]->label);
    }

    return QString("");
}

QString Server::getCPUName()
{
    return m_cpuName;
}

QString Server::getQC71Profile()
{
    QString profile = "";
    uint32_t mode;

    if (slb_qc71_profile_get(&mode) == 0) {
        switch (mode) {
            case SLB_QC71_PROFILE_ENERGY_SAVER:
                profile = "energy-saver";
            break;

            case SLB_QC71_PROFILE_BALANCED:
                profile = "balanced";
            break;

            case SLB_QC71_PROFILE_PERFORMANCE:
                profile = "performance";
            break;
        }
    }

    return profile;
}

QVariantList Server::getTDP()
{
    QVariantList tdp;

    stringstream out;
    
    if (m_cpuName.contains("Intel")) {
        tdp<<200.0<<200<<200; //hack
    }
    
    if (m_cpuName.contains("AMD")) {
        int status = get_process_output("ryzenadj", {"--dump-table"}, out);

        if (status == 0) {
            int n = -1;
            
            while (!out.eof()) {
                string line;
                
                std::getline(out,line);
                
                n++;
                
                if (n < 3) {
                    continue;
                }
                vector<string> tmp = split(line,'|');
                
                if (tmp.size() > 2) {
                    string raw_offset = trim(tmp[0]);
                    string raw_value = trim(tmp[2]);
                    
                    uint32_t offset = std::stoi(raw_offset,0,16);
                    double value = std::stof(raw_value);
                    
                    if (offset == 0x0000 or offset == 0x0008 or offset == 0x0010) {
                        tdp<<offset<<value;
                    }
                    
                }
                
            }
        }
    }
    return tdp;
}
