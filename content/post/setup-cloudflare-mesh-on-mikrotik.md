---
title: Setup Cloudflare Mesh on MikroTik
description: Setup Cloudflare Mesh (formerly WARP Connector) site-to-site VPN on RouterOS
date: 2025-03-10T00:04:00+08:00
lastmod: 2026-05-27T05:50:00+08:00
tags:
  - Cloudflare
  - RouterOS
  - MikroTik
  - WireGuard
  - IPv6
  - tutorials
---
[Cloudflare Mesh](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-mesh/) (formerly WARP Connector) is an overlay network like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard just like NordVPN Meshnet.

Finally, a free site-to-site VPN from Cloudflare.

Because Cloudflare Mesh uses WireGuard, we can run a Cloudflare Mesh node on MikroTik.

## Generate Cloudflare Mesh WireGuard configuration

Follow this [tutorial](../setup-cloudflare-mesh-using-wireguard/) in order to get the WireGuard configuration for the Cloudflare Mesh node.

### Assign your private IP range to Cloudflare Mesh routes

For example, your MikroTik is in IP range `192.168.1.0/24` and you want other devices in your Cloudflare One site-to-site VPN to access all devices under `192.168.1.0/24`.

1. Go to [Networks → Routes](https://dash.cloudflare.com/?to=/:account/one/networks/routes).
2. Click [Add CIDR route](https://dash.cloudflare.com/?to=/:account/one/networks/routes/add).
3. Input your MikroTik's IP range in CIDR, like `192.168.1.0/24`.
4. Select your Cloudflare Mesh node name in Tunnel.
5. Click Create.

### Configure Split Tunneling for your private IP range

This allows your private IP range traffic to pass though the WireGuard instead of getting handled as local traffic.

1. Go to [Team & Resources → Devices → Device profiles](https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/profiles).
2. Click [Default profile → Edit](https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/device-profiles/default).
3. Click ["Manage" on Split Tunnels](https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/device-profiles/default/split-tunnels/exclude/exclude_office_ips_disabled).
4. Remove IP range that is in your MikroTik IP range. For example, your MikroTik is in IP range `192.168.1.0/24`, then remove `192.168.0.0/16`.
5. Apply the same step on the "Cloudflare Mesh" profile you [duplicated earlier](../setup-cloudflare-mesh-using-wireguard/#create-a-separate-device-profile-for-the-cloudflare-mesh-nodes).

## Setup MikroTik Cloudflare Mesh WireGuard

1. Add a new WireGuard interface.\
`/interface wireguard add mtu=1420 name=Cloudflare-Mesh private-key="your_private_key"`
2. Add WireGuard peer to connect to Cloudflare PoP. If you got an endpoint IPv4 address starting with `162.159.192.x`, use `162.159.193.x` instead to have lower latency.[^1] Persistent keepalive is enabled so that the tunnel will not timeout when not in use.\
`/interface wireguard peers add allowed-address=0.0.0.0/0,::/0 endpoint-address=162.159.193.1 endpoint-port=2408 interface=Cloudflare-Mesh name=Cloudflare-PoP persistent-keepalive=1m public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="`

## Setup IPv4

1. Add Cloudflare Mesh's IPv4 address to the WireGuard interface.\
`/ip address add address=100.96.0.1/32 interface=Cloudflare-Mesh`
2. Add Cloudflare One CGNAT IPv4 range to routes.\
`/ip route add dst-address=100.96.0.0/12 gateway=Cloudflare-Mesh`

### Routing other site's IPv4 range

If you have another site that is also routed to Cloudflare Mesh, you can route its IPv4 range so that your MikroTik can access it.\
For example, if your other site's IPv4 range is `192.168.2.0/24`:
```
/ip route add dst-address=192.168.2.0/24 gateway=Cloudflare-Mesh
```

You can repeat multiple times if you have multiple sites.

## Setup IPv6

Cloudflare Mesh does support site-to-site IPv6, but as of this testing, its seems like it is broken, so we use NAT66 for the meantime, and IPv6 port forwarding is needed.\
It is recommended to just set a static IPv6 address to every device that needs IPv6 port forwarding instead of relying on SLAAC so that the IPv6 address for port forwarding does not change.

1. Add Cloudflare Mesh's IPv6 address to the WireGuard interface.\
`/ipv6 address add address=2606:4700:cf1:1000::1/128 interface=Cloudflare-Mesh`
2. [Generate IPv6 ULA](https://unique-local-ipv6.com) and add it to your LAN interface.\
`/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=no interface=bridge`
3. Enable NAT66. Yes, I know NAT is bad, awful when we are talking about IPv6, but since Cloudflare Mesh only provides a single IPv6 address, it's necessary to use NAT in IPv6. The `to-address` should be set to the IPv6 address of the WireGuard interface.\
`/ipv6 firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-Mesh to-address=2606:4700:cf1:1000::1`
4. Add an IPv6 route.
   1. If you don't have native IPv6, add the default route, this allows you to get IPv6 connectivity to your devices.\
   `/ipv6 route add dst-address=::/0 gateway=Cloudflare-Mesh`
   2. If you already have native IPv6, add the Cloudflare One internal IPv6 range.\
   `/ipv6 route add dst-address=2606:4700:cf1:1000::/64 gateway=Cloudflare-Mesh`
5. Allow the IPv6 firewall to accept packets that are port forwarded. (Optional if you want to port forward on IPv6.)\
`/ipv6 firewall filter set [find action=drop chain=forward in-interface-list="!LAN"] comment="defconf: drop everything else not coming from LAN not DSTNATed" connection-nat-state=!dstnat`

### IPv6 port forwarding example

The `dst-address` should be set to the IPv6 address of the WireGuard interface.

To port forward TCP port `8080` of `fd00:1234:5678:9abc::1`:
```
/ipv6 firewall nat add action=dst-nat chain=dstnat dst-address=2606:4700:cf1:1000::1 dst-port=8080 in-interface=Cloudflare-Mesh protocol=tcp to-address=fd00:1234:5678:9abc::1
```

## Test site-to-site VPN

### On your device inside your LAN

1. Try to ping and access the server that is on the other site's IP range.

### On your device outside your LAN

1. Download Cloudflare One Client on your device.
2. Login to Cloudflare Zero Trust.
3. Turn on Cloudflare Zero Trust.
4. Try to ping and access the server that is on the MikroTik's IP range.

[^1]: [Cloudflare One Client with firewall: WARP ingress IP](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/deployment/firewall/#warp-ingress-ip)