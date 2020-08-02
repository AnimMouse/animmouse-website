---
title: "Atrack Torrent Tracker"
date: 2020-08-02T00:20:21+08:00
comments: false
images:
---
Atrack is a Bittorrent tracker designed from the ground up to run on [Google’s App Engine](https://cloud.google.com/appengine/) grid.

Atrack is based on the abandoned [Atrack](http://repo.cat-v.org/atrack/) by [Uriel †](https://github.com/uriel).

## Features
1. It uses memcache to store IP addresses, ports, and hashes/keys.
2. It uses [ntrack](http://repo.cat-v.org/atrack/ntrack), the Network Tracker protocol.
3. It is a torrent tracker running in Google's fast servers.
4. It also aims to respect your privacy, other than what is needed for the most basic tracking (hashes/keys and IP/ports) atrack gathers no information whatsoever.

[Atrack Website](https://atrack.eu.org/)

Source Code on [GitHub](https://github.com/AnimMouse/atrack)