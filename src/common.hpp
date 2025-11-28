// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef SLIMBOOK_CONTROLPANEL_COMMON
#define SLIMBOOK_CONTROLPANEL_COMMON

#include <string>
#include <vector>
#include <sstream>

namespace slimbook
{
    namespace controlpanel
    {

        void read_device(std::string path, std::string &out);
        void read_device(std::string path, double &out);

        std::vector<std::string> split(std::string input,char sep);
        std::string trim(std::string in);

        int get_process_output(std::string filename, std::vector<std::string> args, std::stringstream& out);
        
    }
}

#endif
