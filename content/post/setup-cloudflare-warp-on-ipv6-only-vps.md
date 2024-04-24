---
title: Setup Cloudflare WARP on IPv6 Only VPS
description: Get IPv4 connectivity and setup Cloudflare Zero Trust on your IPv6 only VPS
date: 2024-04-15T20:29:00+08:00
tags:
  - Cloudflare
  - WireGuard
  - VPS
  - IPv6
  - tutorials
---
IPv6 only VPSes are becoming popular right now, since some providers are now requiring you to pay to have an IPv4 address because of the IPv4 address exhaustion. But what if you need to connect to IPv4 only servers on your VPS? And also, what if you wanted to connect to your IPv6 only VPS on your IPv4 only device? Cloudflare WARP and Zero Trust has got you covered.

Note that this will only allow you to connect to your VPS using IPv4 if your client is connected to Cloudflare WARP since Cloudflare WARP only provides a single NATed IPv4, not a public IPv6 address.

## Cloudflare Zero Trust settings

### Cloudflare WARP-to-WARP

1. Go to Settings, and Network.
2. Enable Proxy.
3. Check UDP and ICMP.
4. Enable WARP to WARP.

### Let Cloudflare assign the WARP-to-WARP IPv4 range to devices

Instead of getting the same IP address of `172.16.0.2` to every device, we instead enable "Override local interface IP" so that devices get their own unique IP from `100.96.0.0/12`.

1. Go to Settings, and WARP Client.
2. Enable Override local interface IP.

### Configure Split Tunneling

This allows Cloudflare WARP-to-WARP traffic to pass though the WireGuard instead of getting handled as local traffic.

1. Go to Settings, and WARP Client.
2. Click Default profile, and configure.
3. Make sure split tunnels is set to Exclude IPs and domains.
4. Click "Manage" on Split Tunnels.
5. Remove IP range `100.64.0.0/10` and `fd00::/8`.

## Generate Cloudflare Zero Trust WireGuard configuration

1. Download [wgcf-teams](https://github.com/poscat0x04/wgcf-teams/releases/latest).
2. Open wgcf-teams. `wgcf-teams`
3. On your browser, open `https://<YOUR_ORGANIZATION>.cloudflareaccess.com/warp`.
4. Login to Cloudflare Zero Trust on your browser.
5. After logging in to Cloudflare Zero Trust, get your JWT token using this [guide](https://github.com/poscat0x04/wgcf-teams/blob/master/guide.md).
6. Paste the JWT token on the command prompt that is opened by wgcf-teams and press enter.

The program will output a WireGuard configuration like this:
```conf
# routing-id: 0x000000
[Interface]
PrivateKey = your_private_key
Address = 2606:4700:110:8ced:11b5:d064:abc:ee90/128
Address = 100.96.0.2/32
DNS = 1.1.1.1
DNS = 2606:4700:4700::1111
MTU = 1420

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0
AllowedIPs = 0.0.0.0/0
Endpoint = engage.cloudflareclient.com:2408
```

## Setup Cloudflare WARP WireGuard on your VPS

This assumes that you have Debian installed on your VPS.

1. Install WireGuard. `sudo apt install wireguard`
2. Create WireGuard configuration. `sudo nano /etc/wireguard/wg0.conf`

Paste this WireGuard configuration and edit.
```conf
# routing-id: 0x000000
[Interface]
PrivateKey = your_private_key

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0
AllowedIPs = 0.0.0.0/0
Endpoint = engage.cloudflareclient.com:2408
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
```

4. Enable the WireGuard interface. `sudo ifup wg0`
5. Check if WireGuard is working. `sudo wg`

## Testing

1. Try to ping and access an IPv4 only server on your VPS.
2. Try to ping and access your VPS via its IPv4 address on a device with Cloudflare WARP running.