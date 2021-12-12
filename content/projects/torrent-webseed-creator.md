---
title: Torrent Webseed Creator
date: 2021-01-26T19:11:21+08:00
lastmod: 2021-12-07T21:45:00+08:00
categories:
  - projects
---
[Torrent Webseed Creator](https://github.com/AnimMouse/torrent-webseed-creator)

Webseeded Torrent Creator using GitHub Actions.

An alternative to [BurnBit †](https://web.archive.org/web/20160304022643/http://burnbit.com/) and [URLHash](http://www.urlhash.com/).

I made this because of the shutdown of BurnBit and the sometimes not working URLHash.

For people who wants to create a torrent and backed by webseed.\
For people with a slow internet, create a torrent that is resumable.

## GitHub Actions Hackathon 2021

Back in the day, we have BurnBit that allows us to leverage the P2P power of BitTorrent for our files hosted on our web servers. BurnBit downloads the file in their servers and creates a .torrent metadata of the file and adds your web server as an HTTP webseed for that torrent. This works flawlessly, your file is getting downloaded from your server and at the same time, with other peers already downloaded the file through seeding. This saves bandwidth on your web server, costing you less, and improves the download experience of your users if your web server can't handle the load.

Fast-forward today, BurnBit got down, and there are no alternatives until URLHash, but URLHash has limits, and sometimes goes down.

This GitHub Action workflow allows you to create .torrent file from a direct HTTP link of your web sever and uses that link for webseeding.

This will download the file from your HTTP link and hash it using a torrent creator program using GitHub Actions.

[Burnbit Turns Any Web-Hosted File into a Torrent Article](https://lifehacker.com/burnbit-turns-any-web-hosted-file-into-a-torrent-5637855)

[Burn Any Web-Hosted File into a Torrent With Burnbit Article](https://torrentfreak.com/burn-any-web-hosted-file-into-a-torrent-with-burnbit-100913/)