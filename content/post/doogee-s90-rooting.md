---
title: "Doogee S90 Rooting"
date: 2021-01-26T19:16:21+08:00
draft: true
tags:
  - tutorials
---
## How to root Doogee S90

### Download and install this first
* [Universal ADB Drivers](https://adb.clockworkmod.com/)
* [Minimal ADB and Fastboot](https://forum.xda-developers.com/t/tool-minimal-adb-and-fastboot-2-9-18.2317790/)

### Download and extract this
* [SP Flash Tool](https://androidmtk.com/smart-phone-flash-tool)

### Download and install to phone
* [Magisk](https://github.com/topjohnwu/Magisk/releases)

1. Update the phone first.
2. Unlock the bootloader. (Backup your files, this will erase all of your data)
   1. Enable USB debugging and OEM unlocking in Developer options
   2. Turn off your phone.
   3. Hold volume up and power, until it shows selection screen.
   4. Using volume up, select fastboot mode, and click using volume down.
   5. Connect your phone to your PC with a USB cable.
   6. Open command prompt for adb and fastboot.
   7. Type `fastboot devices` to verify if the phone is connected
   8. Type `fastboot oem unlock` to unlock bootloader. (This will factory reset your device)
   9. Type `fastbook reboot` to reboot device.
3. Install Magisk.apk on S90
4. 