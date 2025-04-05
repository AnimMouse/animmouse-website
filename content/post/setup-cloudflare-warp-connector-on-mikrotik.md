---
title: Setup Cloudflare WARP Connector on MikroTik
description: Setup Cloudflare Zero Trust site-to-site VPN on RouterOS
date: 2025-03-10T00:04:00+08:00
lastmod: 2025-04-05T23:44:00+08:00
tags:
  - Cloudflare
  - RouterOS
  - MikroTik
  - WireGuard
  - IPv6
  - tutorials
---
Cloudflare WARP is an overlay network just like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard.

Finally, a free site-to-site VPN from Cloudflare.

Because Cloudflare WARP uses WireGuard, we can run Cloudflare WARP Connector on MikroTik.

## Cloudflare Zero Trust settings

### Cloudflare WARP-to-WARP

1. Go to Settings, and then Network.
2. Enable Proxy.
3. Check UDP and ICMP.
4. Enable Allow WARP to WARP connection.

### Let Cloudflare assign the WARP-to-WARP IPv4 range to devices

Instead of getting the same IP address of `172.16.0.2` to every device, we instead enable "Override local interface IP" so that devices get their own unique IP from `100.96.0.0/12`.

1. Go to Settings, and then WARP Client.
2. Enable Override local interface IP.

### Configure Split Tunneling

This allows Cloudflare WARP-to-WARP traffic to pass though the WireGuard instead of getting handled as local traffic.

1. Go to Settings, and then WARP Client.
2. Click "Default" profile, and then click Edit.
3. Make sure split tunnels is set to Exclude IPs and domains.
4. Click "Manage" on Split Tunnels.
5. Remove IP range `100.64.0.0/10`.
6. Add IP range `100.64.0.0/11` and `100.112.0.0/12`. (Optional)

### Create WARP Connector tunnel

1. Go to Networks, and then Tunnels.
2. Click Create a tunnel.
3. Select WARP Connector.
4. Make sure all prerequisites are enabled, and then next step.
5. Name your tunnel, and then Create tunnel.
6. Copy the WARP Connector token at step 3 that starts with `eyJhIjoi`, and then click next step.
7. Click Return to Tunnels.

### Assign your private IP range to routes

For example, your MikroTik is in IP range `192.168.1.0/24` and you want other devices in your Cloudflare WARP site-to-site VPN to access all devices under `192.168.1.0/24`.

1. Go to Networks, and then Routes.
2. Click Create route.
3. Input your MikroTik's IP range in CIDR, like `192.168.1.0/24`.
4. Select your WARP Connector tunnel name in Tunnel.
5. Click Create.

## Generate Cloudflare WARP Connector WireGuard configuration

1. Open a terminal with Docker installed. It is recommended to use GitHub Codespaces if you have a GitHub account.
2. Using [wgcf-connector](https://github.com/AnimMouse/wgcf-connector), enter this command in terminal, replacing `<token>` with the token you copied earlier that starts with `eyJhIjoi`.

```sh
docker run --rm -v $(pwd):/app/output ghcr.io/animmouse/wgcf-connector <token>
```

The program will output a file wgcf-connector-<registration_id>.conf in your current working directory with contents like this:

```conf
# Registration ID: 00000000-0000-0000-0000-000000000000
# Organization: organization_name
[Interface]
PrivateKey = your_private_key
Address = 2606:4700:cf1:1000::1/64
Address = 100.96.0.1/12
DNS = 2606:4700:4700::1111
DNS = 1.1.1.1
MTU = 1420

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0
AllowedIPs = 0.0.0.0/0
Endpoint = 162.159.193.1:2408
#Endpoint = [2606:4700:100::a29f:c102]:2408
```

## Setup MikroTik Cloudflare WARP WireGuard

1. Add a new WireGuard interface.\
`/interface wireguard add mtu=1420 name=Cloudflare-WARP private-key="your_private_key"`
2. Add WireGuard peer to connect to Cloudflare WARP. For Zero Trust, `162.159.193.1` should be the endpoint to reduce latency.[^1] Persistent keepalive is enabled so that the tunnel will not timeout when not in use.\
`/interface wireguard peers add allowed-address=0.0.0.0/0,::/0 endpoint-address=162.159.193.1 endpoint-port=2408 interface=Cloudflare-WARP name=Cloudflare-PoP persistent-keepalive=1m public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="`

## Setup IPv4

1. Add Cloudflare WARP's IPv4 address to the WireGuard interface.\
`/ip address add address=100.96.0.1/12 interface=Cloudflare-WARP`

### Routing other site's IPv4 range

If you have another site that is also routed to Cloudflare WARP, you can route its IPv4 range so that your MikroTik can access it.\
For example, if your other site's IPv4 range is `192.168.2.0/24`:
```
/ip route add dst-address=192.168.2.0/24 gateway=Cloudflare-WARP
```

You can repeat multiple times if you have multiple sites.

## Setup IPv6

Cloudflare WARP Connector does not support site-to-site IPv6, so IPv6 port forwarding is needed.\
It is recommended to just set a static IPv6 address to every device that needs IPv6 port forwarding instead of relying on SLAAC so that the IPv6 address for port forwarding does not change.

1. Add Cloudflare WARP's IPv6 address to the WireGuard interface.\
`/ipv6 address add address=2606:4700:cf1:1000::1/64 interface=Cloudflare-WARP`
2. [Generate IPv6 ULA](https://unique-local-ipv6.com) and add it to your LAN interface.\
`/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=no interface=bridge`
3. Enable NAT66. Yes, I know NAT is bad, awful when we are talking about IPv6, but since Cloudflare WARP only provides a single IPv6 address, it's necessary to use NAT in IPv6. The `to-address` should be set to the IPv6 address of the WireGuard interface.\
`/ipv6 firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-WARP to-address=2606:4700:cf1:1000::1`
4. Add an IPv6 route. If you already have native IPv6, you probably don't need to set this up. If you don't have native IPv6, this allows you to get IPv6 connectivity to your devices. (Optional)\
`/ipv6 route add dst-address=::/0 gateway=Cloudflare-WARP`
5. Allow the IPv6 firewall to accept packets that are port forwarded. (Optional if you want to port forward on IPv6.)\
`/ipv6 firewall filter set [find action=drop chain=forward in-interface-list="!LAN"] comment="defconf: drop everything else not coming from LAN not DSTNATed" connection-nat-state=!dstnat`

### IPv6 port forwarding example

The `dst-address` should be set to the IPv6 address of the WireGuard interface.

To port forward TCP port `8080` of `fd00:1234:5678:9abc::1`:
```
/ipv6 firewall nat add action=dst-nat chain=dstnat dst-address=2606:4700:cf1:1000::1 dst-port=8080 in-interface=Cloudflare-WARP protocol=tcp to-address=fd00:1234:5678:9abc::1
```

## Test site-to-site VPN

### On your device inside your LAN

1. Try to ping and access the server that is on the other site's IP range.

### On your device outside your LAN

1. Download Cloudflare WARP on your device.
2. Login to Cloudflare Zero Trust.
3. Turn on Cloudflare Zero Trust.
4. Try to ping and access the server that is on the MikroTik's IP range.

[^1]: [WARP with firewall: WARP ingress IP](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/deployment/firewall/#warp-ingress-ip)