---
title: How to Format and Mount External Hard Drive on Raspberry Pi
description: Format as Btrfs and Mount USB External HDD on Raspberry Pi
date: 2023-04-28T19:58:00+08:00
tags:
  - Raspberry Pi
  - Ubuntu
  - Linux
  - tutorials
---
Use your external hard drive formatted to Btrfs for your Raspberry Pi.

## Select HDD
1. Find your external HDD.\
`lsblk | grep -i "sd"`
2. Find the partition on external HDD.\
`sudo fdisk -l`
3. Enter fdisk for formatting by selecting your external HDD.\
`sudo fdisk /dev/sda`

## fdisk
1. Delete partition. `d`
2. Create partition. `n`
4. Select partition number. `1`
5. Select the first sector instead of using the default 2048, since my external HDD has range of 34-976773134, I choose 34. `34`
6. Select the last sector. The default is the last sector, so just enter it.
7. Write changes to disk. This will delete all data on the external HDD. `w`

## Btrfs format
1. Format external HDD to Btrfs with label Raspberry-Pi-HDD, label is there for easier mounting.\
`sudo mkfs.btrfs -L Raspberry-Pi-HDD /dev/sda1`

You can change label at any time by using this command:\
`sudo btrfs filesystem label /dev/sda1 Raspberry-Pi-HDD`

## Mounting
1. Create a mount point on `/mnt` folder.\
`sudo mkdir /mnt/HDD`
2. Mount external HDD.\
`sudo mount /dev/disk/by-label/Raspberry-Pi-HDD /mnt/HDD`
3. Own the external HDD. By default, it is owned by root.\
`sudo chown -R $USER:$USER /mnt/HDD`

Now every time you reboot your Raspberry Pi, you can mount it again using:\
`sudo mount /dev/disk/by-label/Raspberry-Pi-HDD /mnt/HDD`

## fstab
For automatic mount upon reboot, add this line on your `/etc/fstab` by using `sudo nano /etc/fstab`. Be careful with this file as it can easily cause your system not to boot.
```
LABEL=Raspberry-Pi-HDD /mnt/HDD btrfs nofail,x-systemd.device-timeout=5s 0 0
```
Nofail so that system will not error if the external HDD is disconnected upon boot, and systemd.device-timeout so that system will not wait 90 seconds for the device to appear if disconnected, only 5 seconds.