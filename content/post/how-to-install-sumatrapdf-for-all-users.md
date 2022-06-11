---
title: How to Install Sumatra PDF for All Users
description: Install Sumatra PDF system wide for all users
date: 2020-12-18T00:56:17+08:00
lastmod: 2022-06-09T21:50:00+08:00
tags:
  - Windows
  - tutorials
---
Update: As of version 3.4, Sumatra PDF has now provided system wide for all users in their installer. This tutorial is not needed anymore.

To install Sumatra PDF for all users, all you need is to check "Install for all users" checkbox or add `-all-users` in command prompt.

This post is archived for future reference.

> Sumatra PDF does not provide system wide GUI installer yet. So we need to use workaround to install it system wide.
> 1. Download [Sumatra PDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer.html).
> 2. Open Command Prompt.
> 3. Change directory to the folder where you downloaded SumatraPDF. If it is in Downloads, enter `cd Downloads`.
> 4. Enter `SumatraPDF-3.3-64-install.exe -s -with-preview -d "C:\Program Files\SumatraPDF"`.
>
> Replace "SumatraPDF-3.3-64-install.exe" with the file name of the installer. (Leave at is if you don't need to change it.)\
> Replace "C:\Program Files\SumatraPDF" with your preferred install location. (Leave at is if you don't need to change it.)
>
> Explanation:\
> -s : silent installation. Doesn't show any UI\
> -d <directory> : set directory where program is installed.\
> -with-preview : install shell preview (for viewing PDF on Explorer)
>
> Sources:
> [SumatraPDF documentation](https://www.sumatrapdfreader.org/docs/Installer-cmd-line-arguments.html)\
> [SumatraPDF system wide installer (all users)](https://forum.sumatrapdfreader.org/t/sumatrapdf-v3-2-system-wide-installer-all-users/2809)