---
title: "How to Install GUI on Google Compute Engine VPS"
date: 2020-08-13T20:46:45+08:00
comments: false
images:
---
Installing Graphical User Interface (GUI) on Ubuntu is easy on Google Compute Engine VPS, or any VPS that let's you have shell.

1. `sudo apt update` Update package lists.
2. `sudo apt upgrade` Upgrades all software.
3. `sudo apt install lxqt` Install LXQT desktop.
4. `sudo apt install tightvncserver` Install Tight VNC server. Or install your preferred VNC server.
5. `vncserver` This will start vncserver, type your password.
6. Tunnel port 5901 on SSH.
7. Connect to localhost:5901 on your preferred VNC client.

If you restarted the VPS, just type `vncserver` again to run VNC server.