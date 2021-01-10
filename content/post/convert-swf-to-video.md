---
title: "Convert SWF to Video"
date: 2020-09-07T01:08:01+08:00
tags:
  - tutorials
---
## How to Convert Adobe Flash SWF Flash file to Video/Movie/MP4/MKV file

### Swivel
For Windows, the easiest way to convert SWF to video is [Swivel](https://www.newgrounds.com/wiki/creator-resources/flash-resources/swivel) by [Newgrounds](https://www.newgrounds.com)

To use, just follow the instructions on the website.

Can also convert SWF that is tricky/interactive/complex on Manual Mode.

### GNU Gnash
Using the dump-gnash of the GNU Gnash. My recommended option.

Can be used in Linux and Windows (on Windows Subsystem for Linux)

Converting SWF animations to videos is easy if your SWF files are not tricky, not interactive, that plays when opened automatically. If your SWF file is tricky, there is multiple ways to deal with it.

1. Install GNU Gnash `sudo apt install gnash`

2. `dump-gnash -1 -r 1 -j 1920 -k 1080 -D out.raw input.swf` Where: -j width | -k height 
This will output a raw bgra32 video file at 1080p (1920x1080) \
You can use other resolutions, SWF is vector and it will scale. Tried it already at 8k (7680x4320) resolution.

3. For audio, it is better to extract the audio using SWF Decompiler, or if you have a copy of the audio and mux it in FFmpeg later.
If you really need the audio during extraction, use -A switch. Example: `dump-gnash -1 -r 1 -j 1920 -k 1080 -D out.raw -A out.wav input.swf` \
This will output a WAV audio file.

4. Convert the raw video file to mp4 or mkv and mux the audio file to the video file. I use FFmpeg, you can use any converter and/or muxer you like.
`ffmpeg -hide_banner -r 24 -f rawvideo -pixel_format rgb32 -video_size 1920x1080 -i out.raw -i out.wav $YOUR_ENCODING_COMMANDS` Where: -r framerate of the video

### Dealing with complex SWF file

If your SWF file is tricky, there is multiple ways to deal with it.

1. By recording it while using it. [flaz14 documented](https://flaz14.github.io/misc/swf-to-mp4/swf-to-mp4.html) it how to do it.

2. By removing the interactive elements using a SWF decompiler. My recommented SWF decompiler is [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler) that can remove the interactive parts.