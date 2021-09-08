---
title: "How to Enable zRAM in Linux Mint"
description: "Configure zRAM swap on Linux Mint"
date: 2021-06-03T00:37:37+08:00
tags:
  - Linux Mint
  - Ubuntu
  - Linux
  - tutorials
---
If you have a fast CPU and/or don't want swap eating up your storage, zRAM is for you.

zRAM dedicates a portion of your RAM to act as a swap space, but compressed to save RAM.\
This is faster than traditional swap on HDD and SSD as it uses the speed of the RAM.

To enable zRAM in Linux Mint, just type this on terminal:

`sudo apt install zram-config`

And reboot your system, zRAM is now configured in your Linux Mint.