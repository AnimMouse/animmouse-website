---
title: Setup Cloudflare WARP on IPv6 Only VPS
description: Get IPv4 connectivity and setup Cloudflare WARP or Zero Trust on your IPv6 only VPS
date: 2024-04-15T20:29:00+08:00
lastmod: 2025-09-01T08:47:00+08:00
tags:
  - Cloudflare
  - WireGuard
  - VPS
  - IPv6
  - tutorials
---
IPv6 only VPSes are becoming popular right now, since some providers are now requiring you to pay to have an IPv4 address because of the IPv4 address exhaustion. But what if you need to connect to IPv4 only servers on your VPS? And also, what if you wanted to connect to your IPv6 only VPS on your IPv4 only device? Cloudflare WARP and Zero Trust has got you covered.

Note that this will only allow you to connect to your VPS using IPv4 if your client is connected to Cloudflare Zero Trust since Cloudflare WARP only provides a single NATed IPv4, not a public IPv6 address.

## Cloudflare Zero Trust via WARP Connector (Recommended for those who have Cloudflare account)

Follow this [tutorial](../setup-cloudflare-warp-connector-using-wireguard/) in order to get the WireGuard configuration for the Cloudflare WARP Connector.

## Cloudflare WARP free (For those who don't have Cloudflare account)

## Generate Cloudflare WARP account

1. Download [wgcf](https://github.com/ViRb3/wgcf/releases/latest).
2. Register new account. `wgcf register`
3. Generate WireGuard profile. `wgcf generate`

Now you will have wgcf-profile.conf like this:
```conf
[Interface]
PrivateKey = your_private_key
Address = 172.16.0.2/32, 2606:4700:110:8ced:11b5:d064:abc:ee89/128
DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001
MTU = 1280
[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = engage.cloudflareclient.com:2408
```

## Setup Cloudflare WARP WireGuard on your VPS

This assumes that you have Debian installed on your VPS.

1. Install WireGuard. `sudo apt install wireguard`
2. Create WireGuard configuration. `sudo nano /etc/wireguard/wg0.conf`

Paste this WireGuard configuration and edit.
```conf
[Interface]
PrivateKey = your_private_key

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0, 0.0.0.0/0
Endpoint = engage.cloudflareclient.com:2408 # Paste your Cloudflare WARP endpoint here.
PersistentKeepAlive = 60
```

3. Create a new WireGuard interface configuration.\
`sudo nano /etc/network/interfaces.d/wg0`

Paste this WireGuard interface configuration and edit.
```
auto wg0
iface wg0 inet static
    address 100.96.0.2/12 # Paste your Cloudflare WARP IPv4 address here. Replace `/32` subnet to `/12` so that a dynamic IPv4 route will automatically be created.
    pre-up ip link add $IFACE type wireguard
    pre-up wg setconf $IFACE /etc/wireguard/$IFACE.conf
    post-up ip route add default dev $IFACE # This creates a default IPv4 route going to the WireGuard interface.
    pre-down ip route del default dev $IFACE
    post-down ip link del $IFACE
iface wg0 inet6 static
    address 2606:4700:cf1:1000::2/64 # Paste your Cloudflare WARP IPv6 address here. Replace `/32` subnet to `/12` so that a dynamic IPv6 route will automatically be created.
```

4. Enable the WireGuard interface. `sudo ifup wg0`
5. Check if WireGuard is working. `sudo wg`

## Testing

1. Try to ping and access an IPv4 only server on your VPS.
2. Try to ping and access your VPS via its IPv4 address on a device with Cloudflare WARP running.