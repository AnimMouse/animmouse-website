---
title: OpenNIC Anycast goes down
description: OpenNIC Anycast Tier 2 DNS Resolvers goes down
date: 2022-03-25T00:35:33+08:00
tags:
  - dev
---
I have been using OpenNIC DNS servers recently, and wondering why some of my devices like our TCL smart TV can't connect to the internet but our computers can.

Troubleshooting my network, I found the culprit: OpenNIC Anycast goes down.

These are the IP address of OpenNIC Anycast servers:
```
185.121.177.177
169.239.202.202
2a05:dfc7:5::53
2a05:dfc7:5::5353
```

And checking OpenNIC's wiki, they removed the Anycast IP address on [2021-11-16T21:22:49Z](https://wiki.opennic.org/start?rev=1637097769)

It seems like our smart TV did not handle DNS server failure as well as our computers by using ISP DNS instead.

It is sad to see OpenNIC Anycast go, since then I moved my DNS to [NextDNS](https://nextdns.io/?from=an434x59) and our smart TV is now working well.