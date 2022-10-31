---
title: How to Enable Teredo in Windows
description: Enable Teredo in Windows 10 and 11
date: 2022-08-26T23:58:18+08:00
lastmod: 2022-09-01T13:24:00+08:00
tags:
  - Windows
  - IPv6
  - tutorials
---
Windows 10 version 1803 and later disable Teredo by default, so we need to enable it in order to get IPv6 behind NAT using Teredo.

1. Choose Teredo server [here](../list-of-teredo-servers/).
2. Open an elevated command prompt.
3. Type `netsh interface teredo show state` to show the status of Teredo tunnel.
4. Type `netsh interface teredo set state client example.com` replacing example.com with your chosen Teredo server.
5. Type `netsh interface teredo show state` to show the status of Teredo tunnel.
   1. If state says offline and error says "client is in a managed network", type `netsh interface teredo set state enterpriseclient`.
   2. If state says dormant, Teredo has been enabled.
6. Try to ping an IPv6 server or use [test-ipv6.com](https://test-ipv6.com).
7. Type `netsh interface teredo show state` to show the status of Teredo tunnel. If state says qualified, then your Teredo tunnel is working.