---
title: "How to Install Sumatra PDF for All Users"
description: "Install Sumatra PDF System Wide for All Users"
date: 2020-12-18T00:56:17+08:00
lastmod: 2021-07-09T00:39:00+08:00
tags:
  - tutorials
---
Sumatra PDF does not provide system wide GUI installer yet. So we need to use workaround to install it system wide.
1. Download [Sumatra PDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer.html)
2. Open Command Prompt
3. Change directory to the folder where you downloaded SumatraPDF. If it is in Downloads, enter `cd Downloads`
4. Enter `SumatraPDF-3.3-64-install.exe -s -with-preview -d "C:\Program Files\SumatraPDF"`\
Replace "SumatraPDF-3.3-64-install.exe" with the file name of the installer. (Leave at is if you don't need to change it.)\
Replace "C:\Program Files\SumatraPDF" with your preferred install location. (Leave at is if you don't need to change it.)

Explanation:\
-s : silent installation. Doesn't show any UI\
-d <directory> : set directory where program is installed.\
-with-preview : install shell preview (for viewing PDF on Explorer)

Sources:\
[SumatraPDF documentation](https://www.sumatrapdfreader.org/docs/Installer-cmd-line-arguments.html)\
[SumatraPDF system wide installer (all users)](https://forum.sumatrapdfreader.org/t/sumatrapdf-v3-2-system-wide-installer-all-users/2809)