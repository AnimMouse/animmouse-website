---
title: Set up IPv6 Netmap on MikroTik
description: Perform NPTv6-like translation with stateful firewall on RouterOS
date: 2026-05-26T11:30:00+08:00
tags:
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
IPv6 Netmap is a stateful, 1:1 translation mechanism that modifies only the network prefix of an IPv6 address, leaving the host identifier unchanged.
Unlike NPTv6, it preserves connection tracking and stateful firewall while maintaining address transparency.\
This allows for:

1. Local Prefix Control: Use stable internal addresses (e.g., ULA) regardless of ISP changes.
2. BGP-free Multihoming: Easily map a single internal network to multiple upstream providers.
3. 1-to-1 NAT: No port-mapping required.
4. An NPTv6-like translation while maintaining security through stateful firewall.

Example Mapping:
* Internal: `fd00::1` → External: `2001:db8::1`
* Internal: `fd00::2` → External: `2001:db8::2`

Unlike NPTv6 that will perform a checksum-neutral mapping, Netmap will preserve the actual IPv6 prefix.

Use cases:
1. ISPs or VPNs that only provides /64 and does not provide prefix delegation. You can give your end devices IPv6 connectivity while retaining end-to-end connectivity.
2. Deprioritizing IPv6 tunnel broker connection. You typically don't want to use the IPv6 tunnel broker connection as it has higher latency than native IPv4, so you deprioritize it by using ULA while retaining the ability to host globally accessible services.
3. Handling dynamic IPv6 prefix by the ISP. Some ISP gives dynamic prefix, which means you have to renumber again if the prefix changes. Netmap makes your internal prefix stable.

Considerations:

Unlike NPTv6, this will require your router to maintain state tables and recalculate TCP/UDP checksums, thus making it much slower than wire-speed capability as provided by stateless NPTv6.

## Setup IPv6 Netmap

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN.\
`/ipv6 nd set [ find default=yes ] interface=bridge`

2. Add a Unique Local Address. This is equivalent to IPv4 private network addressing.
   1. [Generate your ULA prefix](https://unique-local-ipv6.com) on `fd00::/8`. Example: `fd00:1234:5678:9abc::/64`
   2. Add IPv6 ULA in your LAN interface.\
   `/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=yes interface=bridge`

3. Enable IPv6 Netmap
   1. Choose the right interface depending on where the IPv6 connectivity is coming from. Replace `ether1` with the right interface.
   2. Add NAT entry for outgoing traffic. `src-address` must be the ULA and the `to-address` must be the GUA.\
   `/ipv6 firewall nat add action=netmap chain=srcnat out-interface=ether1 src-address=fd00:1234:5678:9abc::/64 to-address=2001:db8::/64`
   3. Add NAT entry for incoming traffic. `dst-address` must be the GUA and the `to-address` must be the ULA.\
   `/ipv6 firewall nat add action=netmap chain=dstnat in-interface=ether1 dst-address=2001:db8::/64 to-address=fd00:1234:5678:9abc::/64`

4. Make sure you have an IPv6 route that goes to the gateway on where the IPv6 connectivity is coming from. If the route does not exist, add a route.
   1. Choose the right gateway depending on where the IPv6 connectivity is coming from.
   2. Add route entry.\
   `/ipv6 route add dst-address=::/0 gateway=ether1`

5. Try to ping an IPv6 server or use [test-ipv6.run](https://test-ipv6.run).\
If you get "Your browser uses IPv4 by default" on test-ipv6.run, this is normal as IPv4 has higher metric than IPv6 ULA. To prefer IPv6, either change the metric on your device or use an unallocated address like `ace:cab:deca:deed::/64`.