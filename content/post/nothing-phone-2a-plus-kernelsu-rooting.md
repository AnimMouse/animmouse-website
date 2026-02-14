---
title: Nothing Phone 2a Plus KernelSU Rooting
description: How to root the Nothing Phone 2a Plus using SukiSU Ultra with SUSFS
date: 2026-02-12T17:10:00+08:00
tags:
  - Android
  - tutorials
---
APatch is now getting detected by my banking apps, and I need money.

APatch still does not have a way to hide root efficiently via the kernel, I tried "Cherish Peekaboo" and "NoHello KPM" and root is still being detected, so it is time to switch to KernelSU.

SukiSU Ultra is a fork of KernelSU with SUSFS (Suspicious File System) built-in.

Fortunately, Nothing Phone 2a Plus uses a GKI kernel, so we can use a patched kernel to our boot.img image. We will install KernelSU in GKI mode.

## Prerequisites
1. [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)
2. [Google USB Driver](https://developer.android.com/studio/run/win-usb)
3. [SukiSU-Ultra](https://github.com/SukiSU-Ultra/SukiSU-Ultra)
4. [MagiskBoot](https://github.com/svoboda18/magiskboot)

## Get boot.img
1. Update the phone first.
2. Get your build number. For this example, my build number is `PacmanPro-V3.2-250904-1704`.
3. Go to [Nothing Archive 2a Plus](https://github.com/spike0en/nothing_archive?tab=readme-ov-file#nothing-phone-2a-plus) and find your build number there.
4. Click OTA Images for your build number.
5. Download `image-boot.7z`. Example: `PacmanPro_V3.2-250904-1704-image-boot.7z`
6. Extract archive to get `boot.img`.

## KMI matching and download patched kernel
1. Learn how Kernel Module Interface (KMI) works at the [KernelSU guide](https://kernelsu.org/guide/installation.html#kmi).
2. Get your kernel version at your phone settings. For this example, my kernel version is `5.15.167-android13-8`.
3. Go to the [SukiSU installation guide](https://github.com/SukiSU-Ultra/SukiSU-Ultra/blob/main/docs/guide/installation.md) and choose your kernel flavor. For this example, I will use [MiRinFork](https://github.com/MiRinFork/GKI_SukiSU_SUSFS).
4. By matching the KMI version with the original version and the patched version, you will find out that my example matched `5.15.185-android13` in the MiRinFork.
5. Download the matching kernel. For this example, I will download `android13-5.15.185-2025-07-AnyKernel3.zip`.
6. Extract the archive to get `Image`, this is the patched kernel.

## Patch kernel inside boot.img
1. Create a folder and place `magiskboot.exe` and `boot.img` we got earlier.
2. Execute `magiskboot unpack boot.img` to unpack the `boot.img`, this will output a `kernel` file, which is your stock kernel.
3. Delete the `kernel` file, and then put the `Image` file we got earlier. Rename the patched kernel to `kernel`.
4. Execute `magiskboot repack boot.img`, this will output `new-boot.img`, this is your new patched `boot.img` to be flashed via fastboot.

## Unlock bootloader
If you already unlocked the bootloader since you are migrating from APatch, skip this step.\
Back up your files; this will erase all of your data.

1. Enable USB debugging and OEM unlocking in Developer options.
2. Connect your phone to your computer.
3. `adb devices` to allow ADB access.
4. `adb reboot bootloader` to reboot to bootloader.
5. `fastboot devices` to verify if the phone is connected.
6. `fastboot flashing unlock` to unlock bootloader. (This will factory reset your device.)
7. `fastboot reboot` to reboot device.

## Flashing
1. Connect your phone to your computer.
2. `adb reboot bootloader` to reboot to bootloader.
3. `fastboot getvar current-slot` to get current active slot.
4. `fastboot flash boot_[slot] new-boot.img` to flash the patched `boot.img`. Example with slot B: `fastboot flash new-boot.img`
5. `fastboot reboot` to reboot device.
6. Open SukiSU Ultra and verify if root is working.

## Post-installation
1. Install metamodule for module support. Recommended: Hybrid Mount
2. Reboot.
3. Install Tricky Store, Tricky Addon, and Play Integrity Fork.
4. SUSFS will work automatically, no need to configure SUSFS unless needed.

## OTA Updates
1. Disable all modules. Delete all modules if upgrading to a major Android version.
2. Restore your original `boot.img` using fastboot.
3. Perform the OTA update.
4. Patch your `boot.img`.
5. Flash your new `new-boot.img`.
6. Enable your modules.

## Fastboot device can't be found
1. Go to Device Manager.
2. If the driver is in warning, update the driver using the `android_winusb.inf`.
3. Select "Android Bootloader Interface".