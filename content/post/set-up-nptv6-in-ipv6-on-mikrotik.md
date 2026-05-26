---
title: Set up NPTv6 in IPv6 on MikroTik
description: Perform IPv6 Network Prefix Translation on RouterOS
date: 2026-02-14T23:35:00+08:00
lastmod: 2026-05-27T06:04:00+08:00
tags:
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
IPv6-to-IPv6 Network Prefix Translation (NPTv6) is a stateless, 1:1 translation mechanism that modifies only the network prefix of an IPv6 address, leaving the host identifier unchanged.
Unlike traditional NAT, it preserves end-to-end connectivity by maintaining address transparency.\
This allows for:

1. Local Prefix Control: Use stable internal addresses (e.g., ULA) regardless of ISP changes.
2. BGP-free Multihoming: Easily map a single internal network to multiple upstream providers.
3. Stateless: No port-mapping or state tables required.

Example Mapping:
* Internal: `fd00::1` → Desired External: `2001:db8::1` → Actual External: `2001:db8::cf47:0:0:1`
* Internal: `fd00::2` → Desired External: `2001:db8::2` → Actual External: `2001:db8::cf47:0:0:2`

Take note that actual external IP will be different, as NPTv6 will perform a checksum-neutral mapping.

Use cases:
1. ISPs or VPNs that only provides /64 and does not provide prefix delegation. You can give your end devices IPv6 connectivity while retaining end-to-end connectivity.
2. Deprioritizing IPv6 tunnel broker connection. You typically don't want to use the IPv6 tunnel broker connection as it has higher latency than native IPv4, so you deprioritize it by using ULA while retaining the ability to host globally accessible services without the complexity of traditional NAT.
3. Handling dynamic IPv6 prefix by the ISP. Some ISP gives dynamic prefix, which means you have to renumber again if the prefix changes. NPTv6 makes your internal prefix stable.

Considerations:

Unfortunately, due to the architecture of the Linux Netfilter kernel, you will need to disable IPv6 stateful firewall for packets that are being rewritten on NPTv6 as the mangle table, where the NPTv6 resides, cannot communicate with the conntrack engine that powers the stateful firewall, requiring us to use notrack in order to make NPTv6 work.\
Because of this, MikroTik tracks the rewritten IPv6 packets and drops the packets as invalid, so we need to disable connection tracking.

You can either:
1. NPTv6 without a stateful firewall, and then you rely on your end client's own firewall.
2. NPTv6 with a stateless firewall, but not effective on UDP packets.
3. Instead of NPTv6, use [IPv6 Netmap](../set-up-ipv6-netmap-on-mikrotik/).

## Setup IPv6 NPTv6

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN.\
`/ipv6 nd set [ find default=yes ] interface=bridge`

2. Add a Unique Local Address. This is equivalent to IPv4 private network addressing.
   1. [Generate your ULA prefix](https://unique-local-ipv6.com) on `fd00::/8`. Example: `fd00:1234:5678:9abc::/64`
   2. Add IPv6 ULA in your LAN interface.\
   `/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=yes interface=bridge`

3. Enable NPTv6
   1. Choose the right interface depending on where the IPv6 connectivity is coming from. Replace `ether1` with the right interface.
   2. Add mangle entry for outgoing traffic. Source prefix must be the ULA and the destination prefix must be the GUA.\
   `/ipv6 firewall mangle add action=snpt chain=postrouting out-interface=ether1 src-address=fd00:1234:5678:9abc::/64 src-prefix=fd00:1234:5678:9abc::/64 dst-prefix=2001:db8::/64`
   3. Add mangle entry for incoming traffic. Source prefix must be the GUA and the destination prefix must be the ULA.\
   `/ipv6 firewall mangle add action=dnpt chain=prerouting in-interface=ether1 dst-address=2001:db8::/64 src-prefix=2001:db8::/64 dst-prefix=fd00:1234:5678:9abc::/64`

4. Disable connection tracking on the ULA prefix.\
   Warning, this will disable the stateful firewall on every packets rewritten by NPTv6.
   1. Add raw entry for outgoing traffic.\
   `/ipv6 firewall raw add action=notrack chain=prerouting src-address=fd00:1234:5678:9abc::/64`
   2. Add raw entry for incoming traffic.\
   `/ipv6 firewall raw add action=notrack chain=prerouting dst-address=2001:db8::/64`

5. Make sure you have an IPv6 route that goes to the gateway on where the IPv6 connectivity is coming from. If the route does not exist, add a route.
   1. Choose the right gateway depending on where the IPv6 connectivity is coming from.
   2. Add route entry.\
   `/ipv6 route add dst-address=::/0 gateway=ether1`

6. Try to ping an IPv6 server or use [test-ipv6.run](https://test-ipv6.run).\
If you get "Your browser uses IPv4 by default" on test-ipv6.run, this is normal as IPv4 has higher metric than IPv6 ULA. To prefer IPv6, either change the metric on your device or use an unallocated address like `ace:cab:deca:deed::/64`.