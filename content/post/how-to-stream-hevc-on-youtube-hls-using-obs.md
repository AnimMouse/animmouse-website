---
title: How to Stream HEVC on YouTube HLS Using OBS
description: Stream HEVC (H.265) on YouTube using Open Broadcaster Software
date: 2021-09-12T22:45:07+08:00
lastmod: 2022-12-27T00:53:00+08:00
tags:
  - YouTube
  - tutorials
---
Update: As of version 28, Open Broadcaster Software (OBS) has now provided an option to stream HEVC without workaround.

YouTube now [supports HEVC (H.265) ingestion](https://developers.google.com/youtube/v3/live/guides/ingestion-protocol-comparison) if you use HTTP Live Streaming (HLS).

For best results have a hardware encoder that can encode to HEVC (H.265).

## Create YouTube HLS Stream Key
1. Click Select stream key.
2. At the dropdown, select Create new stream key.
3. Name your key, I used "HLS stream key" as a name.
4. At the Streaming protocol dropdown, select "HLS (Advanced)".
5. Create and use your new HLS stream key.

## Stream HEVC on YouTube HLS using OBS
1. Go to Settings, and then Stream.
2. At the Service dropdown, select YouTube - HLS.
3. Click "Use Stream key".
4. Copy the stream key from your YouTube Studio and paste it to OBS.
5. Go to Output, and go to Streaming.
6. On Encoder, select HEVC codec.

## Old workaround
Before version 28, OBS does not support streaming HEVC on YouTube HLS. Back then, in order to stream HEVC on OBS, we need to use OBS's FFmpeg custom output to URL on it's recording.

This post is archived for future reference.

> YouTube now [supports HEVC (H.265) ingestion](https://developers.google.com/youtube/v3/live/guides/ingestion-protocol-comparison) if you use HTTP Live Streaming (HLS), but Open Broadcaster Software (OBS) as of version 27.2.4 still does not support streaming HEVC on YouTube HLS. So in order to stream HEVC on OBS, we need to use OBS's FFmpeg custom output to URL on it's recording.
>
> ### Stream HEVC on YouTube HLS using OBS
> 1. Go to Settings, and then Output.
> 2. Use Advanced output mode and go to Recording tab.
> 3. Use Custom Output (FFmpeg) on Type.
> 4. Use Output to URL on FFmpeg Output Type.
> 5. Copy the Stream URL from your YouTube Studio and paste it to "File path or URL" and append `index.m3u8` to it.
> For example if your URL is `https://a.upload.youtube.com/http_upload_hls?cid=****-****-****-****-****&copy=0&file=` then it must be `https://a.upload.youtube.com/http_upload_hls?cid=****-****-****-****-****&copy=0&file=index.m3u8`.
> 6. Use "hls" on Container format.
> 7. Click Show all codecs checkbox.
> 8. At the video encoder, you can choose what encoder to use. If you are using Nvidia use hevc_nvenc, for AMD use hevc_amf, for Intel use hevc_qsv.
> 9. For audio encoder you can use aac or for better quality use libopus (not just opus) and I tested libopus on YouTube and it works even though it is undocumented.
> 10. Now you can tweak Video and Audio Bitrate. My preferred settings are 3000 Kbps on Video for HEVC and 96 Kbps on Audio for libopus or 128 Kbps for aac.
> 11. Save the settings.
>
> Now you can stream HEVC to YouTube by clicking "Start Recording" (not Start Streaming, yes this is counterintuitive but it is what it is. OBS should add a feature that allow custom output on Start Streaming.)