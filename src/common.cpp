// This file is part of Slimbook ControlPanel - <https://github.com/Slimbook-Team/slimbook-controlpanel>
// SPDX-FileCopyrightText: 2025 Slimbook development team <dev@slimbook.com>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "common.hpp"

#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#include <string>
#include <vector>
#include <fstream>

using namespace slimbook::controlpanel;

using namespace std;

void slimbook::controlpanel::read_device(string path, string &out) {
    ifstream file;

    file.open(path.c_str());
    std::getline(file, out);
    file.close();
}

void slimbook::controlpanel::read_device(string path, double &out) {
    string tmp;
    read_device(path,tmp);

    out = std::stol(tmp);
}

vector<string> slimbook::controlpanel::split(string input,char sep)
{
    vector<string> tmp;
    bool knee = false;
    string current;

    for (char c:input) {

        if (c != sep) {
            current.push_back(c);
            knee = true;
        }
        else {
            if (knee == true) {
                tmp.push_back(current);
                current="";
                knee = false;
            }

        }
    }

    if (current.size() > 0) {
        tmp.push_back(current);
    }

    return tmp;
}

string slimbook::controlpanel::trim(string in)
{
    string out;
    size_t first = 0;
    size_t last = 0;
    bool ffound = false;
    
    for (size_t n=0;n<in.size();n++) {
        char c = in[n];
        
        if (!ffound and c!=' ') {
            ffound = true;
            first = n;
        }
        
        if (c!=' ') {
            last = n;
        }
    }
    out = in.substr(first,last+1);
    
    return out;
}

int slimbook::controlpanel::get_process_output(string filename, vector<string> args, stringstream& out)
{
    int outpipe[2];

    if (pipe(outpipe) == -1) {
        return 1;
    }

    pid_t pid = fork();

    if (pid == -1) {
        return 1;
    }

    if (pid == 0) {
        char* argv[32];
        argv[0] = (char*)filename.c_str();
        int n = 1;
        int argc = std::min((size_t)31,args.size() + 1);

        while (n<argc) {
            argv[n] = (char*)args[n-1].c_str();
            n++;
        }
        argv[n] = nullptr;

        dup2(outpipe[1], STDOUT_FILENO);
        close(outpipe[0]);
        close(outpipe[1]);

        execvp(filename.c_str(),argv);
    }
    else {
        close(outpipe[1]);
        int ofd = outpipe[0];

        char buffer;
        while (read(ofd,&buffer,1) > 0) {
            out<<buffer;
        }

        close(ofd);

        int status;
        int value;

        waitpid(pid, &status, 0);

        if (WIFEXITED(status)) {
            value = WEXITSTATUS(status);
        }

        if (WIFSIGNALED(status)) {
            value = -WTERMSIG(status);
        }

        return value;
    }

    // ?
    return 1;
}


