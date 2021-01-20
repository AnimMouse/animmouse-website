---
title: "How to Install SumatraPDF for All Users"
date: 2020-12-18T00:56:17+08:00
tags:
  - tutorials
---
1. Download [SumatraPDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer.html)
2. Open Command Prompt
3. Change directory to the folder where you downloaded SumatraPDF. If in Downloads, enter `cd Downloads`
4. Enter `SumatraPDF-3.2-64-install.exe -s -with-preview -d "C:\Program Files\SumatraPDF"`
Replace "SumatraPDF-3.2-64-install.exe" with the file name of the installer\
Replace "C:\Program Files\SumatraPDF" with the install location.

Explanation:
-s : silent installation. Doesn't show any UI
-d <directory> : set directory where program is installed.
-with-preview : install shell preview (for viewing PDF on Explorer)

Source: [SumatraPDF documentation](https://www.sumatrapdfreader.org/docs/Installer-cmd-line-arguments.html)