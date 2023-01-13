---
title: How to NAT IPv6 in MikroTik
description: NAT masquerade IPv6 in RouterOS
date: 2022-10-28T20:29:22+08:00
lastmod: 2023-01-13T19:33:00+08:00
tags:
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
You have an IPv6 connectivity in your WAN or you use a VPN, but sadly it only provides `/128`, requiring you to do NAT.

Yes, I know NAT is bad, really bad when we are talking about IPv6, but since your provider only provides a single IPv6 address, only the router has IPv6 connectivity, and the rest of your devices doesn't.

So we need to perform NAT66 or masquerade to be able to access the IPv6 internet when you only have a single IPv6 address.

RouterOS v7.1 and up supports NAT66.

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN.\
`/ipv6 nd set [ find default=yes ] interface=bridge`

2. Add a Unique Local Address. This is equivalent to IPv4 private network addressing.
   1. Choose your ULA prefix on `fd00::/8`. Example: `fd00:1234:5678:9000::/64`
   2. Add IPv6 ULA in your LAN interface.\
   `/ipv6 address add address=fd00:1234:5678:9000::/64 advertise=yes interface=bridge`

3. Enable NAT66.
   1. Choose the right out-interface. Either `out-interface-list=WAN` or `out-interface=ether1` depending on where the IPv6 connectivity is coming from.
   2. Add NAT entry on IPv6.\
   `/ipv6 firewall nat add action=masquerade chain=srcnat ipsec-policy=out,none out-interface=ether1`

4. Try to ping an IPv6 server or use [test-ipv6.com](https://test-ipv6.com).\
If you get "Your browser has a real working IPV6 address but is avoiding using it." on test-ipv6.com, this is normal as IPv4 has higher metric than IPv6 ULA. To prefer IPv6 ULA, either change the metric or use an unallocated address like `ace:cab:deca:deed::/64`.