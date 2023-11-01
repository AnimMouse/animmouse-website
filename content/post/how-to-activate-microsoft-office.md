---
title: How to Activate Microsoft Office
description: Activating/Cracking Microsoft Office for free
date: 2021-09-07T21:50:00+08:00
lastmod: 2023-11-02T01:59:00+08:00
tags:
  - Microsoft Office
  - Windows
  - tutorials
---
Download the latest [Microsoft Activation Scripts (MAS)](https://github.com/massgravel/Microsoft-Activation-Scripts) [here](https://github.com/massgravel/Microsoft-Activation-Scripts/archive/refs/heads/master.zip).

Microsoft Activation Scripts will automatically convert retail licensed Microsoft Office to volume license, so no need to use [office-C2R-to-VOL](https://github.com/kkkgo/office-C2R-to-VOL).

## Method 1: Ohook
This method will activate Microsoft Office by placing a custom `sppc.dll` file in Office folder.

1. Extract Microsoft-Activation-Scripts-master.zip
2. Go to MAS\Separate-Files-Version\Activators\
3. Run Ohook_Activation_AIO.cmd in Administrator.
4. Press 1 to activate Microsoft Office.

## Method 2: External KMS Server
This method will activate Microsoft Office against external KMS servers, leaving no traces of activator in your PC.

1. Extract Microsoft-Activation-Scripts-master.zip
2. Go to MAS\Separate-Files-Version\Activators\
3. Run Online_KMS_Activation.cmd in Administrator.
4. Press 2 to activate Microsoft Office only.

The script has built-in list of KMS servers to choose from, it will choose automatically the best KMS server for you.

After 180 days, it will automatically reactivate against the script's chosen external KMS server.

For being a proud viewer of this website, I host a vlmcsd KMS emulator that you can use for free at `kms.0000004.xyz`.

1. Open command prompt in administrator.
2. Set KMS server. `cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /sethst:kms.0000004.xyz`
3. Activate on the KMS server. `cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act`

## Method 3: Internal KMS Server / KMS Emulator
This method will activate Microsoft Office against internal KMS emulator installed on your PC, so it can activate and renew without internet.

1. Extract Microsoft-Activation-Scripts-master.zip
2. Go to MAS\Separate-Files-Version\Activators\
3. Run Online_KMS_Activation.cmd in Administrator.
4. Press 2 to activate Microsoft Office only.
5. Press 4 to install auto-renewal.

"Support the software developers, if you like this software, BUY IT!" - RELOADED