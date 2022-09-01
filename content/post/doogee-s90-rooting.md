---
title: Doogee S90 Rooting
description: How to root the Doogee S90 using Magisk
date: 2021-01-26T19:16:21+08:00
lastmod: 2022-09-01T12:12:00+08:00
tags:
  - tutorials
---
The rugged Doogee S90 is currently my main phone.

## Prerequisites
1. [Universal ADB Drivers](https://adb.clockworkmod.com)
2. [Minimal ADB and Fastboot](https://forum.xda-developers.com/t/tool-minimal-adb-and-fastboot-2-9-18.2317790/)
3. [SP Flash Tool](https://androidmtk.com/smart-phone-flash-tool)
4. [Magisk](https://github.com/topjohnwu/Magisk/releases)

## Rooting
1. Update the phone first. Make sure the build number is `DOOGEE_S90_Android8.1-20191205`.
2. Unlock the bootloader. (Backup your files, this will erase all of your data.)
   1. Enable USB debugging and OEM unlocking in Developer options.
   2. Turn off your phone.
   3. Hold volume up and power, until it shows selection screen.
   4. Using volume up, select fastboot mode, and click using volume down.
   5. Connect your phone to your PC using a USB cable.
   6. Open command prompt for adb and fastboot.
   7. Type `fastboot devices` to verify if the phone is connected.
   8. Type `fastboot oem unlock` to unlock bootloader. (This will factory reset your device.)
   9. Type `fastbook reboot` to reboot device.
3. Install Magisk.apk on S90.
4. Download boot.img [here](https://github.com/AnimMouse/Doogee-S90-Magisk/blob/main/stock/boot.img). (Or readback boot.img using SP Flash Tool. (Advanced))
5. Patch boot.img in Magisk.
6. Flash patched boot.img using SP Flash Tool.
   1. Download scatter-loading file [here](https://github.com/AnimMouse/Doogee-S90-Magisk/blob/main/MT6771_Android_scatter.txt). (Or create your own scatter file using MTK Droid Tool. (Advanced))
   2. Select boot.img in SP Flash Tool.
   3. Turn off your phone.
   4. Click Download.
   5. Connect your phone to your PC using a USB cable.
   6. If download ok shows, disconnect your phone.
7. Open Magisk to verify if Magisk has been installed.

## Backup
To prevent problems later on, it is recommended to readback important partitions in your phone to prevent a brick if something goes wrong.