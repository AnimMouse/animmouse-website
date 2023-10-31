---
title: Get IPv6 Connectivity on MikroTik Using Cloudflare WARP
description: Connect to IPv6 only servers on your IPv4 only internet using Cloudflare WARP on RouterOS
date: 2022-10-31T01:34:12+08:00
lastmod: 2023-10-31T22:56:00+08:00
tags:
  - Cloudflare
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
You don't have an IPv6 connection but the server you need to connect has only an IPv6 address because of the IPv4 address exhaustion and some providers are now requiring you to pay to have an IPv4 address.

Note that this will only provide an IPv6 connectivity, not a public IPv6 address that you can connect to from the outside since Cloudflare WARP only provides a single NATed IPv6.

## Generate Cloudflare WARP account

1. Download [wgcf](https://github.com/ViRb3/wgcf/releases/latest).
2. Register new account. `wgcf register`
3. Generate WireGuard profile. `wgcf generate`

Now you will have wgcf-profile.conf like this:
```conf
[Interface]
PrivateKey = your_private_key
Address = 172.16.0.2/32
Address = 2606:4700:110:8ced:11b5:d064:abc:ee89/128
DNS = 1.1.1.1
MTU = 1280
[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408
```

## Setup MikroTik Cloudflare WARP WireGuard

1. Add new WireGuard interface with private key from wgcf-profile.conf.\
`/interface wireguard add mtu=1420 name=Cloudflare-WARP private-key="your_private_key"`
2. Add WireGuard peer to connect to Cloudflare WARP with endpoint address and port, and public key from wgcf-profile.conf. It is better to set allowed address to `2000::/3` instead of `::/0` so that only global unicast will get routed.\
`/interface wireguard peers add allowed-address=2000::/3 endpoint-address=engage.cloudflareclient.com endpoint-port=2408 interface=Cloudflare-WARP public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="`

## Setup IPv6

1. Add Cloudflare WARP's IPv6 address to the WireGuard interface.\
`/ipv6 address add address=2606:4700:110:8ced:11b5:d064:abc:ee89/128 interface=Cloudflare-WARP`
2. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN. Take note of the MTU, since the default MTU of WireGuard is 1420, set the MTU of ND to 1420 so that the packets don't fragment.\
`/ipv6 nd set [ find default=yes ] interface=bridge mtu=1420`
3. Add IPv6 ULA to your LAN interface.\
`/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=yes interface=bridge`
4. Enable NAT66. Yes, I know NAT is bad, awful when we are talking about IPv6, but since Cloudflare WARP only provides a single IPv6 address, it's necessary to use NAT in IPv6. The `out-interface` should be the WireGuard interface. The `to-address` should be set to the IPv6 address of the WireGuard interface.\
`/ipv6 firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-WARP to-address=2606:4700:110:8b7b:2edb:5201:dddd:19fd/128`
5. Add IPv6 route that goes to the Cloudflare WARP WireGuard interface.\
`/ipv6 route add dst-address=2000::/3 gateway=Cloudflare-WARP`
6. Try to ping an IPv6 server or use [test-ipv6.com](https://test-ipv6.com).\
If you get "Your browser has a real working IPV6 address but is avoiding using it." on test-ipv6.com, this is normal as IPv4 has higher metric than IPv6 ULA. To prefer IPv6, either change the metric on your device or use an unallocated address like `ace:cab:deca:deed::/64`.

Now you can access IPv6 only servers now via Cloudflare WARP.