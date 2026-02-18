---
title: How to NAT IPv6 in MikroTik
description: IPv6 NAT and port forwarding in RouterOS
date: 2022-10-28T20:29:22+08:00
lastmod: 2026-02-19T02:07:00+08:00
tags:
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
You have an IPv6 connectivity in your WAN or you use a VPN, but sadly it only provides `/128`, requiring you to do NAT.

Yes, I know NAT is bad, awful when we are talking about IPv6, but since your provider only provides a single IPv6 address, only the router has IPv6 connectivity, and the rest of your devices doesn't.

So we need to perform NAT66 or masquerade to be able to access the IPv6 internet when you only have a single IPv6 address.

RouterOS v7.1 and up supports NAT66.

You can also use [NPTv6](../how-to-perform-nptv6-in-ipv6-on-mikrotik/) if your ISP or VPN at least gives `/64`.

## Setup IPv6 NAT

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN.\
`/ipv6 nd set [ find default=yes ] interface=bridge`

2. Add a Unique Local Address. This is equivalent to IPv4 private network addressing.
   1. [Generate your ULA prefix](https://unique-local-ipv6.com) on `fd00::/8`. Example: `fd00:1234:5678:9abc::/64`
   2. Add IPv6 ULA in your LAN interface.\
   `/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=yes interface=bridge`

3. Enable NAT66.
   1. Choose the right out-interface. Either `out-interface-list=WAN` or `out-interface=ether1` depending on where the IPv6 connectivity is coming from.
   2. Add NAT entry.
      1. If you have dynamic IPv6 address, use masquerade.\
      `/ipv6 firewall nat add action=masquerade chain=srcnat out-interface=ether1`
      2. If you have static IPv6 address, use src-nat so that the router don't keep checking whether the IPv6 address was changed. The `to-address` should be set to the IPv6 address of the interface.\
      `/ipv6 firewall nat add action=src-nat chain=srcnat out-interface=ether1 to-address=2001:db8::/128`

4. Make sure you have an IPv6 route that goes to the gateway on where the IPv6 connectivity is coming from. If the route does not exist, add a route.
   1. Choose the right gateway depending on where the IPv6 connectivity is coming from.
   2. Add route entry.\
   `/ipv6 route add dst-address=::/0 gateway=ether1`

5. Allow IPv6 firewall to accept packets that are port forwarded. (Optional)\
`/ipv6 firewall filter set [find action=drop chain=forward in-interface-list="!LAN"] comment="defconf: drop everything else not coming from LAN not DSTNATed" connection-nat-state=!dstnat`

6. Try to ping an IPv6 server or use [test-ipv6.com](https://test-ipv6.com).\
If you get "Your browser has a real working IPV6 address but is avoiding using it." on test-ipv6.com, this is normal as IPv4 has higher metric than IPv6 ULA. To prefer IPv6, either change the metric on your device or use an unallocated address like `ace:cab:deca:deed::/64`.

## IPv6 NAT port forwarding example

The `dst-address` should be set to the IPv6 address of the interface.

To port forward TCP port `8080` of `fd00:1234:5678:9abc::1`:
```
/ipv6 firewall nat add action=dst-nat chain=dstnat dst-address=2001:db8::/128 dst-port=8080 in-interface=ether1 protocol=tcp to-addresses=fd00:1234:5678:9abc::1/128
```