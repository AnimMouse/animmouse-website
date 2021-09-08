---
title: "How to Install DS3231 on Raspberry Pi"
description: "Use/Enable the DS3231 RTC module on Raspberry Pi"
date: 2021-09-04T22:59:45+08:00
tags:
  - Linux Mint
  - Ubuntu
  - Linux
  - tutorials
---
The DS3231 is a low-cost, extremely accurate I²C real-time clock (RTC) with an integrated temperature-compensated crystal oscillator (TCXO) and crystal.

## For Ubuntu for Raspberry Pi:

1. Install the DS3231 module to the Raspberry Pi's GPIO.
2. Add the following text to your usercfg.txt: `dtoverlay=i2c-rtc,ds3231`
3. Test the RTC by entering this command `sudo hwclock -r`. A time string should appear.

## For Raspberry Pi OS (formerly Raspbian):

1. Install the DS3231 module to the Raspberry Pi's GPIO.
2. Uncomment the `dtparam=i2c_arm=on` on the config.txt by removing the # in front of the line. Or use raspi-config to enable I²C.
3. Add the following text below the `[all]` to your config.txt: `dtoverlay=i2c-rtc,ds3231`
4. Test the RTC by entering this command `sudo hwclock -r`. A time string should appear.

Source: [Install DS3231 Real Time Clock - Latest Info](https://www.raspberrypi.org/forums/viewtopic.php?t=161133)