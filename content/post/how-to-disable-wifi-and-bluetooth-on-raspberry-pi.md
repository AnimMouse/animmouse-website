---
title: How to Disable WiFi and Bluetooth on Raspberry Pi
description: Permanently disable the Wi-Fi & Bluetooth of the Raspberry Pi in firmware
date: 2021-09-04T23:49:36+08:00
lastmod: 2022-06-10T13:30:00+08:00
tags:
  - Raspberry Pi
  - Ubuntu
  - Linux
  - tutorials
---
If you are using your Raspberry Pi and you don't need to use the Wi-Fi and Bluetooth like for example if you use it as a desktop or a server, it is recommended to disable it.

Note this disable the interfaces at the hardware level, not software, so it is disabled until you remove the config and reboot the Raspberry Pi.

## For Ubuntu 22.04, and any other distro that doesn't have usercfg.txt:

1. Open the config.txt file located on the boot partition. (/boot/firmware/config.txt inside Raspberry Pi or D:\config.txt (drive letter might be different) in Windows.)
2. Add `dtoverlay=disable-wifi` below the bottommost `[all]` to disable Wi-Fi.
3. Add `dtoverlay=disable-bt` below the bottommost `[all]` to disable Bluetooth.
4. Save and reboot your Raspberry Pi.

## For Ubuntu 20.04, and any other distro that have usercfg.txt:

1. Open the usercfg.txt file located on the boot partition. (/boot/firmware/usercfg.txt inside Raspberry Pi or D:\usercfg.txt (drive letter might be different) in Windows.)
2. Add `dtoverlay=disable-wifi` to disable Wi-Fi.
3. Add `dtoverlay=disable-bt` to disable Bluetooth.
4. Save and reboot your Raspberry Pi.

## For Raspberry Pi OS (formerly Raspbian):

1. Open the config.txt file located on the boot partition. (/boot/config.txt inside Raspberry Pi or D:\config.txt (drive letter might be different) in Windows.)
2. Add `dtoverlay=disable-wifi` under `[all]` to disable Wi-Fi.
3. Add `dtoverlay=disable-bt` under `[all]` to disable Bluetooth.
4. Save and reboot your Raspberry Pi.

To enable it again just remove `dtoverlay=disable-wifi` & `dtoverlay=disable-bt` in your configuration and reboot.

Tested on Raspberry Pi 4 Model B.