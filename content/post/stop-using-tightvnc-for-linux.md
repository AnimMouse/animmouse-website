---
title: Stop using TightVNC for Linux
description: TightVNC for Linux is outdated
date: 2021-07-25T15:55:00+08:00
lastmod: 2022-06-11T21:35:00+08:00
tags:
  - Linux
  - Ubuntu
  - Raspberry Pi
---
Unless you brought [TightVNC license on Server for Unix/Linux/X11](https://www.tightvnc.com/licensing-server-x11.php), you should not using an outdated version of TightVNC.

The last version of TightVNC for Linux that is still open source is [version 1.3.10 released on March 12, 2009](https://lwn.net/Articles/322943/).

## Bugs that I found using old version of TightVNC

1. LXQT crashes on login ["Panel crashed too many times. It's autostart has been disabled until next login."](https://github.com/EXALAB/AnLinux-App/issues/261).
2. Xfce [Missing window decorations in VNC](https://bugs.launchpad.net/ubuntu/+source/xfwm4/+bug/1860921).
3. [Lack of XRender support in the tightvncserver Xserver](https://bugs.launchpad.net/ubuntu/+source/xfwm4/+bug/1860921/comments/11).

## What to do now
Use [TigerVNC](https://tigervnc.org/) instead. Or your preferred VNC server.

1. `sudo apt purge tightvncserver`
2. `sudo apt install tigervnc-standalone-server`

Most of the commands in TightVNC works on TigerVNC.