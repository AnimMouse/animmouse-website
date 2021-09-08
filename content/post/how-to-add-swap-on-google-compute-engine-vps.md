---
title: "How to Add Swap on Google Compute Engine VPS"
date: 2020-08-14T12:20:12+08:00
tags:
  - Linux
  - Ubuntu
  - tutorials
---
By default, Google Compute Engine VPS does not come with any swap space, If your program eat more memory, you can just add swap space instead of increasing RAM.

1. `sudo fallocate -l 2G /swapfile` Create file for swap.
2. `sudo chmod 600 /swapfile` Set the necessary permissions.
3. `sudo mkswap /swapfile` Make it a swap file.
4. `sudo swapon /swapfile` Turn on swapping on the file you created.
5. `sudo swapon -s` Check status of swap file.

To make this permanent add this to /etc/fstab

`/swapfile none swap sw 0 0`

Run `sudo vi /etc/fstab` to edit that file. Or use your preferred text editor.

If you need to resize the swap file

1. `sudo swapoff /swapfile` Turn off swapping.
2. `sudo fallocate -l 4G /swapfile` Change file size, replace 4G with the size you prefer.
3. `sudo mkswap /swapfile` Make it a swap file again.
4. `sudo swapon /swapfile` Turn on swapping again.

Source: [Badly Wired](https://badlywired.com/2016/08/adding-swap-google-compute-engine/)