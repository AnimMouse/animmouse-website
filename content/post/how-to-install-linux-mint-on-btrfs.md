---
title: "How to Install Linux Mint on BTRFS"
description: "Install Linux Mint on B-tree file system"
date: 2021-03-20T19:51:42+08:00
hidden: false
comments: true
tags:
  - downloads
---
#### Do you want to use Timeshift on Linux Mint just like System Restore in Windows?

The B-tree file system or BTRFS is a file system on Linux that behaves like the NTFS on Windows.\
The ext4 file system is a pure file system, do it's one job, no extra stuff like NTFS or BTRFS.\
When you use Timeshift on ext4, it uses rsync to make copies of the files, above the file system, that is why it is slow.\
When you use System Restore on NTFS, the copies of the files are made as an atomic transaction to the file system, that is why it is fast.\
Timeshift on BTRFS behaves like System Restore in Windows.

### Install Linux Mint on BTRFS
This will erase everything on your hard drive.

1. Open Linux Mint installer and follow everything up to Installation Type
2. At installation type, click Something else
3. Click New Partition Table
4. Click free space, and click 'plus'
5. If you are using UEFI, make a 128 MB partition, use as EFI System Partition, leave other options at default.
6. Click the next free space, and click 'plus'
7. Use as btrfs journaling file system with a mount point at '/', leave other options at default.
8. Click install now, and follow the installation.

After installation, set-up Timeshift using the BTRFS option.