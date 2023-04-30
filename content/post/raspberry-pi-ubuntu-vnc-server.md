---
title: Raspberry Pi Ubuntu GUI VNC Server
description: How to install headless GUI VNC Server on Raspberry Pi
date: 2021-09-01T01:27:40+08:00
lastmod: 2022-06-11T21:25:00+08:00
tags:
  - Raspberry Pi
  - Ubuntu
  - Linux
  - tutorials
---
Use your Raspberry Pi as an headless server that has a GUI you can control using VNC.

Pick what desktop environment to use, if you want a barebones desktop just to control the GUI on the Raspberry Pi, use an window manager like Openbox and Fluxbox.\
Or if you want the full desktop experience on your Raspberry Pi, use a full desktop environment like LXQT.

1. Install a window manager or desktop environment. `sudo apt install openbox` for openbox or `sudo apt install lxqt` for LXQT or any other WM/DE like `fluxbox` and `xfce4`.
2. Install TigerVNC Server. `sudo apt install tigervnc-standalone-server`
3. Create a new VNC configuration file. `nano ~/.vnc/tigervnc.conf`
4. Add the following text inside tigervnc.conf to choose your own screen resolution and to enable access outside localhost.
```
$geometry = "1366x768";
$localhost = "no";
```
4. Start TigerVNC Server. This will prompt a new password if password has not yet set. `vncserver`
5. Now you can connect to your Raspberry Pi using VNC on the IP address of your Raspberry Pi.

As the default settings on TigerVNC prevents clients outside the localhost of Raspberry Pi from connecting to the server, the setting `$localhost = "no";` should be included inside tigervnc.conf.

If you have installed multiple window/desktop managers, you can select what to use by `sudo update-alternatives --config x-session-manager`.

If you want to install LXQT without all the recommended packages just append `--no-install-recommends`.
: Example: `sudo apt install lxqt --no-install-recommends`

Tested on Raspberry Pi 4 Model B.

> If you are using Ubuntu 20.04, there is a [bug that kills TigerVNC just after connect](https://github.com/TigerVNC/tigervnc/issues/800), to [fix this](https://github.com/TigerVNC/tigervnc/issues/800#issuecomment-565669421) just append `LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1` if you are using 64-bit Ubuntu before the vncserver command.\
> Example: `LD_PRELOAD=/lib/aarch64-linux-gnu/libgcc_s.so.1 vncserver`\
> For 32-bit Ubuntu use `LD_PRELOAD=/lib/arm-linux-gnueabihf/libgcc_s.so.1`.