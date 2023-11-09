---
title: How to Activate Microsoft Office
description: Activating/Cracking Microsoft Office for free
date: 2021-09-07T21:50:00+08:00
lastmod: 2023-11-10T01:48:00+08:00
tags:
  - Microsoft Office
  - Windows
  - tutorials
---
Download the latest [Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts) [here](https://github.com/massgravel/Microsoft-Activation-Scripts/archive/refs/heads/master.zip).

Microsoft Activation Scripts will automatically convert retail licensed Microsoft Office to volume license if needed, so no need to use [office-C2R-to-VOL](https://github.com/kkkgo/office-C2R-to-VOL).

## Method 1: Ohook
The Ohook activation method is currently the best way of activating Microsoft Office.\
This method will activate Microsoft Office by placing a custom `sppc.dll` file inside the Office folder.

1. Extract `Microsoft-Activation-Scripts-master.zip`.
2. Go to `MAS\Separate-Files-Version\Activators`.
3. Run `Ohook_Activation_AIO.cmd` as Administrator.
4. Press 1 to activate Microsoft Office.

## Method 2: External KMS Server
This method will activate Microsoft Office via an external KMS server, leaving no traces of activator in your PC.\
This activation requires internet and expires after 180 days if not renewed.

1. Extract `Microsoft-Activation-Scripts-master.zip`.
2. Go to `MAS\Separate-Files-Version\Activators`.
3. Run `Online_KMS_Activation.cmd` as Administrator.
4. Press 2 to activate Microsoft Office only.

The script has built-in list of KMS servers to choose from, it will choose automatically the best KMS server for you.

### Automatic renewal via an external KMS server
Install auto-renewal task so that the activation will not expire after 180 days via an external KMS server that is chosen by MAS.\
Take note that this will not renew the activation without an internet connection.

1. Extract `Microsoft-Activation-Scripts-master.zip`.
2. Go to `MAS\Separate-Files-Version\Activators`.
3. Run `Online_KMS_Activation.cmd` as Administrator.
4. Press 2 to activate Microsoft Office only.
5. Press 4 to install online auto-renewal.

### Automatic renewal via a self-hosted external KMS server
You can host your own KMS server using [vlmcsd](https://github.com/Wind4/vlmcsd) or use someone else's KMS server.

1. Open command prompt in administrator.
2. Set the KMS server replacing `kms.example.com` with your chosen KMS server.\
`cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /sethst:kms.example.com`
3. Activate using the KMS server.\
`cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act`
3. Check the status of the activation.\
`cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /dstatus`

If using Office 2013, change `Office16` to `Office15`.

## Method 3: Internal KMS Server / KMS Emulator
This method will automatically renew Microsoft Office activation via an internal KMS emulator installed on your PC, so it can activate and renew without a server hosted on the internet.\
This is the least recommended method as this may trip your antivirus.

1. Download the latest [KMS_VL_ALL_AIO](https://github.com/abbodi1406/KMS_VL_ALL_AIO) [here](https://github.com/abbodi1406/KMS_VL_ALL_AIO/releases/latest).
2. Turn off any real-time antivirus, it may trip off and block activation.
3. Extract the archive with the password as stated on the release page.
4. Run `KMS_VL_ALL_AIO.cmd` as Administrator.
5. Press 2 to install local KMS emulator with auto-renewal.
6. Exclude this file from antivirus: `C:\Windows\System32\SppExtComObjHook.dll` (If you are using Windows Defender, KMS_VL_ALL_AIO will automatically add exclusion for you.)

"Support the software developers, if you like this software, BUY IT!" - RELOADED