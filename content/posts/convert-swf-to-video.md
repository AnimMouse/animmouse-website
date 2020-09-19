---
title: "Convert SWF to Video"
date: 2020-09-07T01:08:01+08:00
comments: true
images:
draft: true
---
How to Convert Adobe Flash SWF Flash file to Video/Movie/MP4/MKV file

### Swivel
For Windows, the easiest way to convert SWF to video is [Swivel](https://www.newgrounds.com/wiki/creator-resources/flash-resources/swivel) by [Newgrounds](https://www.newgrounds.com)

To use, just follow the instructions on the website.

Can also convert SWF that is tricky/interactive/complex on Manual Mode.

### GNU Gnash
The best option for me.

Can be used in Linux and Windows (on Windows Subsystem for Linux)

Converting SWF animations to videos is easy if your SWF files are not tricky, not interactive, that plays when opened automatically. If your SWF file is tricky, there is multiple ways to deal with it.

1. Install GNU Gnash `sudo apt install gnash`
2. `dump-gnash -1 -r 1 -j 1920 -k 1080 -D out.raw@24 input.swf`
Where:
-j width -k height @24 framerate\
This will output bgra32 raw video file.
3. 