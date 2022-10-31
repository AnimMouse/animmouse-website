---
title: How to Access Bridged Modem in MikroTik
description: Access Modem in Bridge Mode on RouterOS
date: 2022-10-29T22:51:45+08:00
tags:
  - RouterOS
  - MikroTik
  - tutorials
---
1. Make sure the LAN IP address subnet of the bridged modem is different from LAN IP address subnet of the router. For example, if the router IP is `192.168.1.1/24`, the modem should be on `192.168.10.1/24`.

2. Add another IP address on the WAN side of the router. This router IP address should be in the same subnet and different address as the modem.\
If your modem is on `192.168.10.1`, use this command: `/ip address add address=192.168.10.2/24 interface=ether1`. This will add another IP address of the router to `192.168.10.2`, allowing you to access the modem at `192.168.10.1`.

3. Now you can access the bridged modem behind the router by going to `192.168.10.1`.