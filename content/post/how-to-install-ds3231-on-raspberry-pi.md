---
title: How to Install DS3231 on Raspberry Pi
description: Use/Enable the DS3231 RTC module on Raspberry Pi
date: 2021-09-04T22:59:45+08:00
lastmod: 2022-06-10T13:25:00+08:00
tags:
  - Raspberry Pi
  - Ubuntu
  - Linux
  - tutorials
---
The DS3231 is a low-cost, extremely accurate I²C real-time clock (RTC) with an integrated temperature-compensated crystal oscillator (TCXO) and crystal.

## For Ubuntu 22.04, and any other distro that doesn't have usercfg.txt:

1. Install the DS3231 module to the Raspberry Pi's GPIO.
2. Open the config.txt file located on the boot partition. (/boot/firmware/config.txt inside Raspberry Pi or D:\config.txt (drive letter might be different) in Windows.)
3. Add the following text below the bottommost `[all]` to your config.txt: `dtoverlay=i2c-rtc,ds3231`.
4. Test the RTC by entering this command `sudo hwclock -r`. A time string should appear.

## For Ubuntu 20.04, and any other distro that have usercfg.txt:

1. Install the DS3231 module to the Raspberry Pi's GPIO.
2. Open the usercfg.txt file located on the boot partition. (/boot/firmware/usercfg.txt inside Raspberry Pi or D:\usercfg.txt (drive letter might be different) in Windows.)
3. Add the following text to your usercfg.txt: `dtoverlay=i2c-rtc,ds3231`.
4. Test the RTC by entering this command `sudo hwclock -r`. A time string should appear.

## For Raspberry Pi OS (formerly Raspbian):

1. Install the DS3231 module to the Raspberry Pi's GPIO.
1. Open the config.txt file located on the boot partition. (/boot/firmware/config.txt inside Raspberry Pi or D:\config.txt (drive letter might be different) in Windows.)
2. Uncomment the `dtparam=i2c_arm=on` on the config.txt by removing the # in front of the line. Or use raspi-config to enable I²C.
3. Add the following text below the `[all]` to your config.txt: `dtoverlay=i2c-rtc,ds3231`.
4. Test the RTC by entering this command `sudo hwclock -r`. A time string should appear.

Tested on Raspberry Pi 4 Model B.

Source: [Install DS3231 Real Time Clock - Latest Info](https://www.raspberrypi.org/forums/viewtopic.php?t=161133)