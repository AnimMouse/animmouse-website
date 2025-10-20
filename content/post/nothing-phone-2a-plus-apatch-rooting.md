---
title: Nothing Phone 2a Plus APatch Rooting
description: How to root the Nothing Phone 2a Plus using APatch
date: 2025-02-23T01:04:00+08:00
lastmod: 2025-10-21T03:44:00+08:00
tags:
  - Android
  - tutorials
---
The Nothing Phone 2a Plus is currently my main phone.

## Prerequisites
1. [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)
2. [Google USB Driver](https://developer.android.com/studio/run/win-usb)
3. [APatch](https://github.com/bmax121/APatch)

## Get and patch boot.img
1. Update the phone first.
2. Get your build number. For this example, my build number is `PacmanPro-U2.6-241217-1545`.
3. Go to [Nothing Archive 2a Plus](https://github.com/spike0en/nothing_archive?tab=readme-ov-file#nothing-phone-2a-plus) and find your build number there.
4. Click OTA Images for your build number.
5. Download `image-boot.7z`. Example: `PacmanPro_U2.6-241217-1545-image-boot.7z`
6. Extract archive to get `boot.img`.
7. Install APatch on your phone.
8. Patch your `boot.img` using APatch. Take note of your SuperKey.

## Rooting
1. Unlock the bootloader. (Backup your files, this will erase all of your data.)
   1. Enable USB debugging and OEM unlocking in Developer options.
   2. Connect phone to your computer.
   3. `adb devices` to allow ADB access.
   4. `adb reboot bootloader` to reboot to bootloader.
   5. `fastboot devices` to verify if the phone is connected.
   6. `fastboot flashing unlock` to unlock bootloader. (This will factory reset your device.)
   7. `fastboot reboot` to reboot device.
2. Flash patched `boot.img` using fastboot.
   1. `adb reboot bootloader` to reboot to bootloader.
   2. `fastboot getvar current-slot` to get current active slot.
   3. `fastboot flash boot_[slot] apatch_patched_XXXXX_X.XX.X.img` to flash the patched `boot.img`. Example with slot B: `fastboot flash boot_b apatch_patched_10763_0.10.7_aobg.img`
   4. `fastboot reboot` to reboot device.
7. Open APatch with your SuperKey to verify if APatch has been installed.

## OTA Updates
1. Disable all modules. Delete all modules if upgrading to a major Android version.
2. Restore your original `boot.img` using fastboot. Take note of your build number.
3. Perform the OTA update.
4. Patch your `boot.img` based on the new build number.
5. Flash your new `boot.img`.
6. Enable your modules.