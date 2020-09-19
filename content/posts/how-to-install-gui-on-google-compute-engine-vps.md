---
title: "How to Install GUI on Google Compute Engine VPS"
date: 2020-08-13T20:46:45+08:00
comments: true
images:
---
Installing Graphical User Interface (GUI) on Ubuntu is easy on Google Compute Engine VPS, or any VPS that let's you have shell.

1. `sudo apt update` Update package lists.
2. `sudo apt upgrade` Upgrades all software.
3. `sudo apt install lxqt` Install LXQT desktop environment.
4. `sudo apt install tightvncserver` Install Tight VNC server. Or install your preferred VNC server.
5. `vncserver` This will start VNC server, provide your VNC password.
6. Tunnel port 5901 on your SSH client.
7. Connect to localhost:5901 on your preferred VNC client. I recommend Tight VNC Client.

If you restarted the VPS, just type `vncserver` again to run VNC server.

If you want to resize the resolution of the desktop, type `vncserver geometry 1920x1080` replacing the resolution of your choice.