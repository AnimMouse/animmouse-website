---
title: How to Use Torrent Webseed Creator
description: A step by step instruction on how to use Torrent Webseed Creator on GitHub
date: 2023-01-12T15:37:42+08:00
tags:
  - GitHub
  - torrent
  - tutorials
---
Torrent Webseed Creator is the alternative to BurnBit and URLHash.

1. Click "Use this template" and then click "Create a new repository".

![Use this template](Use-this-template.png)

2. Type your own repository name, and then click "Create repository from template".

![Create repository from template](Create-repository-from-template.png)

3. Now, you will be redirected to your own repository generated from my template.

![Your own repository](Your-own-repository.png)

4. Go to the Actions tab, and select which one program you will use to create your own torrent. I recommend using torrenttools, but you can use any of them.

![Actions tab](Actions-tab.png) ![torrenttools](torrenttools.png)

5. Click "Run workflow", and input the information about the file you want to create torrent from. I have prefilled the inputs to serve as a guide. And then click "Run workflow" inside the dropdown box. For more information about the inputs, refer to the [README.md](https://github.com/AnimMouse/torrent-webseed-creator/blob/main/README.md#how-to-use) file.

![Dropdown box](Dropdown-box.png)

6. The workflow run has been requested, reload the page to see the running action.

![Workflow run successfully requested](Workflow-run-successfully-requested.png)
![Page reloaded](Page-reloaded.png) ![Page reloaded 2](Page-reloaded-2.png)

7. Click the name of the program you used (In this case: torrenttools) and go to the Artifacts produced during runtime, and then click the name of the torrent you created. This will download the .torrent file inside a .zip file.

![Open torrenttools](Open-torrenttools.png) ![Artifacts](Artifacts.png)