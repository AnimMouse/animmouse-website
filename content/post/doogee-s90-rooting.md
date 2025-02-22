---
title: Doogee S90 Rooting
description: How to root the Doogee S90 using Magisk
date: 2021-01-26T19:16:21+08:00
lastmod: 2025-02-23T01:04:00+08:00
tags:
  - Android
  - tutorials
---
The rugged Doogee S90 is my main phone in the past.

## Prerequisites
1. [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)
2. [Google USB Driver](https://developer.android.com/studio/run/win-usb)
3. [SP Flash Tool](https://androidmtk.com/smart-phone-flash-tool)
4. [Magisk](https://github.com/topjohnwu/Magisk)

## Rooting
1. Update the phone first. Make sure the build number is `DOOGEE_S90_Android8.1-20191205`.
2. Unlock the bootloader. (Backup your files, this will erase all of your data.)
   1. Enable USB debugging and OEM unlocking in Developer options.
   2. Connect phone to your computer.
   3. `adb devices` to allow ADB access.
   4. `adb reboot bootloader` to reboot to bootloader.
   5. Type `fastboot devices` to verify if the phone is connected.
   6. Type `fastboot oem unlock` to unlock bootloader. (This will factory reset your device.)
   7. Type `fastboot reboot` to reboot device.
3. Install Magisk.apk on your phone.
4. Download boot.img [here](https://github.com/AnimMouse/Doogee-S90-Magisk/blob/main/stock/boot.img). (Or readback boot.img using SP Flash Tool. (Advanced))
5. Patch boot.img using Magisk.
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