---
title: "How to Disable WiFi and Bluetooth on Raspberry Pi"
description: "Permanently disable the Wi-Fi & Bluetooth of the Raspberry Pi"
date: 2021-09-04T23:49:36+08:00
tags:
  - Raspberry Pi
  - Ubuntu
  - Linux
  - tutorials
---
If you are using your Raspberry Pi and you don't need to use the Wi-Fi and Bluetooth like for example if you use it as a desktop or a server, it is recommended to disable it.

Note this disable the interfaces at the hardware level, not software, so it is disabled until you removed the config and reboot the Raspberry Pi.

## For Ubuntu for Raspberry Pi:

1. Open the usercfg.txt file.
2. Add `dtoverlay=disable-wifi` to disable Wi-Fi.
3. Add `dtoverlay=disable-bt` to disable Bluetooth.
4. Save and reboot your Raspberry Pi.

## For Raspberry Pi OS (formerly Raspbian):

1. Open the config.txt file.
2. Add `dtoverlay=disable-wifi` under `[all]` to disable Wi-Fi.
3. Add `dtoverlay=disable-bt` under `[all]` to disable Bluetooth.
4. Save and reboot your Raspberry Pi.

To enable it again just remove `dtoverlay=disable-wifi` & `dtoverlay=disable-bt` in your configuration and reboot.