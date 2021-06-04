---
title: "How to Add Swap on Linux Mint Btrfs"
description: "Add Swap on Linux Mint installed on Btrfs"
date: 2021-03-20T21:20:24+08:00
tags:
  - tutorials
---
#### Linux Mint (Ubuntu) always use a swapfile on installation, 
but swapfile on the main subvolume does not work on Btrfs.\
To fix this, we need to create a new subvolume and put the swapfile there.

Assuming that the / is on /dev/sda2 (/dev/sda1 if you are still using old BIOS, /dev/nvme0n1p2 if you are using NVME) and Linux Mint is installed with / on @ subvolume and /home is on @home subvolume.

1. Mount /dev/sda2 to /mnt. `sudo mount /dev/sda2 /mnt`\
If you run `ls /mnt`, you'll see @, @home and other subvolumes that may be there.
2. Create a new @swap subvolume. `sudo btrfs sub create /mnt/@swap`
3. Unmount /dev/sda2 from /mnt `sudo umount /mnt`
4. Create /swap directory where we plan to mount the @swap subvolume. `sudo mkdir /swap`
5. Mount the @swap subvolume to /swap. `sudo mount -o subvol=@swap /dev/sda2 /swap`
6. Create the swap file. `sudo touch /swap/swapfile`
7. Set 600 permissions to the file. `sudo chmod 600 /swap/swapfile`
8. Disable Copy-on-write for this file. `sudo chattr +C /swap/swapfile`
9. Set size of the swap file to 4 GB as an example. `sudo fallocate /swap/swapfile -l 4g`
10. Format the swapfile `sudo mkswap /swap/swapfile`
11. Turn the swap file on. `sudo swapon /swap/swapfile` Now the new swap should be working.
12. Type `sudo xed /etc/fstab` to open in text editor
13. Remove `/swap/swapfile none swap sw 0 0` at the last part.
14. Add these lines at the last part:
```
UUID=XXXXXXXXXXXXXXX /swap btrfs defaults,noatime,subvol=@swap 0 0
/swap/swapfile none swap sw 0 0
```
Use the UUID on the one of your /dev/sda2. Save the file.
15. Remove the old swapfile created by the installer. `sudo rm -f /swapfile`

Sources:\
[Can I have a swapfile on btrfs? 1](https://askubuntu.com/a/1206161)\
[Can I have a swapfile on btrfs? 2](https://askubuntu.com/a/1299060)