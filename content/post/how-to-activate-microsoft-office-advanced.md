---
title: "How to Activate Microsoft Office (Advanced)"
description: "Activating/Cracking Microsoft Office Manually"
date: 2020-08-02T00:33:54+08:00
lastmod: 2021-09-07T22:05:00+08:00
tags:
  - Microsoft Office
  - Windows
  - tutorials
---
Before you proceed, make sure Microsoft Office is volume licensed (not retail). If not, you SHOULD follow this [guide](../how-to-convert-microsoft-office-to-volume/).

This is for advanced users, for the easy way go to [activating Microsoft Office](../how-to-activate-microsoft-office/).

## Method 1: External KMS Server

This method will activate Microsoft Office against external KMS servers, leaving no traces of activator.

1. Open command prompt in administrator.
2. Type `cd C:\Program Files\Microsoft Office\Office16` to change directory to MS Office. If you are using MS Office older than 2016, consult this [site](https://www.ryadel.com/en/microsoft-office-default-installation-folders-versions/) to know your installation folder.
3. Type `cscript ospp.vbs /dstatus` to check the status of the license. It SHOULD be in KMS mode. If not, you are on retail license.
4. Find a list of external KMS server [here](https://gist.github.com/CHEF-KOCH/29cac70239eed583ad1c96dcb6de364b).
5. Type `cscript ospp.vbs /sethst:kms.com` replacing kms.com with your chosen KMS server.
6. Type `cscript ospp.vbs /act` to activate. If it failed to activate after 2 tries, try to [troubleshoot](#troubleshooting-method-1) it.
7. Type `cscript ospp.vbs /dstatus` to check the status of the license. It should be activated. If not, try another KMS server.

After 180 days, it will automatically reactivate against your chosen external KMS server.

## Method 2: Internal KMS Server / KMS Emulator

This method will activate Microsoft Office against internal KMS emulator installed on your PC, so it can activate without internet.

1. Download KMS_VL_ALL tool [here](https://app.box.com/s/6quxrz2zuj3644ov918ogqkihehpfijj) by abbodi1406. [Passwords](https://i.imgur.com/peLYgJX.jpg).
2. Turn off any real time antivirus, it MAY trip off and block activation.
3. Extract the archive.
4. Run AutoRenewal-Setup.cmd as administrator.
5. If you use Antivirus software, it is best to exclude this file from scanning protection: C:\Windows\System32\SppExtComObjHook.dll (If you are using Windows Defender, KMS_VL_ALL will automatically add exclusion for you.

## Troubleshooting Method 1

If method 1 fails to activate after 2 tries, you need to activate it first using KMS_VL_ALL.

1. Download KMS_VL_ALL tool [here](https://app.box.com/s/6quxrz2zuj3644ov918ogqkihehpfijj) by abbodi1406. [Passwords](https://i.imgur.com/peLYgJX.jpg).
2. Turn off any real time antivirus, it MAY trip off and block activation.
3. Extract the archive.
4. Run Activate.cmd as administrator.
5. If it's activated, repeat step 5 in [Method 1](#method-1-external-kms-server).

Source:

1. Reddit [Piracy Megathread](https://www.reddit.com/r/Piracy/wiki/megathread/tools)
2. MyDigitalLife [page](https://forums.mydigitallife.net/threads/kms_vl_all-smart-activation-script.79535/#post-838808)

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

"Support the software developers, if you like this software, BUY IT!" - RELOADED