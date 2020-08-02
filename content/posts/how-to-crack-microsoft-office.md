---
title: "How to Crack Microsoft Office"
date: 2020-08-02T00:33:54+08:00
comments: false
images:
---
Before you proceed, you SHOULD follow this [guide](../how-to-install-microsoft-office-2016).

Method 1: External KMS Server

This method will activate Microsoft Office against external KMS servers, leaving no traces of activator.

1. Open command prompt in administrator.
2. Type `cd C:\Program Files\Microsoft Office\Office16` to change directory to MS Office.
3. Type `cscript ospp.vbs /dstatus` to check the status of the license. It SHOULD be in KMS mode.
4. Find a list of external KMS server [here](https://gist.github.com/CHEF-KOCH/29cac70239eed583ad1c96dcb6de364b).
5. Type `cscript ospp.vbs /sethst:kms.com` replacing kms.com with your chosen KMS server.
6. Type `cscript ospp.vbs /act` to activate.
7. Type `cscript ospp.vbs /dstatus` to check the status of the license. It SHOULD be activated.

After 180 days, it will automatically activate.

Method 2: Internal KMS Server / KMS Emulator

This method will activate Microsoft Office against internal KMS emulator installed on your PC, so it can activate without internet.

1. Download KMS_VL_ALL tool [here](https://app.box.com/s/6quxrz2zuj3644ov918ogqkihehpfijj) by abbodi1406. [Passwords](https://i.imgur.com/peLYgJX.jpg).
2. Turn off any real time antivirus, it MAY trip off and block activation.
3. Extract the archive.
4. Run AutoRenewal-Setup.cmd as administrator.

Source:

1. Reddit [Piracy Megathread](https://www.reddit.com/r/Piracy/wiki/megathread/tools)
2. MyDigitalLife [page](https://forums.mydigitallife.net/threads/kms_vl_all-smart-activation-script.79535/#post-838808)