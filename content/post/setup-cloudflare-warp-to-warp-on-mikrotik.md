---
title: Setup Cloudflare WARP-to-WARP on MikroTik
description: Setup Cloudflare Zero Trust and port forwarding on RouterOS
date: 2023-08-27T00:16:00+08:00
tags:
  - Cloudflare
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
Cloudflare WARP-to-WARP is an overlay network just like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard.

Because Cloudflare WARP uses WireGuard, we can run Cloudflare WARP on MikroTik and port forward on our virtual network at Cloudflare.

## Cloudflare Zero Trust settings

### Cloudflare WARP-to-WARP

1. Go to Settings, and Network.
2. Enable Proxy.
3. Check UDP and ICMP.
4. Enable WARP to WARP.

### Split Tunneling

1. Go to Settings, and WARP Client.
2. Click Default profile, and configure.
3. Make sure split tunnels is set to Exclude IPs and domains.
4. Manage split tunnels.
5. Remove IP range `100.64.0.0/10` and `fd00::/8`.

## Generate Cloudflare Zero Trust WireGuard configuration

1. Download [wgcf-teams](https://github.com/poscat0x04/wgcf-teams/releases/latest).
2. Open wgcf-teams. `wgcf-teams`
3. Login to Cloudflare Zero Trust using this [guide](https://github.com/poscat0x04/wgcf-teams/blob/master/guide.md).
4. Paste the JWT token on the prompt.

The program will output a WireGuard configuration like this:
```
# routing-id: 0x000000
[Interface]
PrivateKey = your_private_key
Address = 2606:4700:110:8ced:11b5:d064:abc:ee89/128
Address = 172.16.0.2/32
DNS = 1.1.1.1
DNS = 2606:4700:4700::1111
MTU = 1420

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0
AllowedIPs = 0.0.0.0/0
Endpoint = engage.cloudflareclient.com:2408
```

## Setup MikroTik Cloudflare WARP WireGuard

1. Add new WireGuard interface.\
`/interface wireguard add mtu=1420 name=Cloudflare-WARP private-key="your_private_key"`
2. Add WireGuard peer to connect to Cloudflare WARP. For Zero Trust, `162.159.193.1` should be the endpoint. Persistent keepalive is enabled so that the tunnel will not timeout when not in use.\
`/interface wireguard peers add allowed-address=0.0.0.0/0,::/0 endpoint-address=162.159.193.1 endpoint-port=2408 interface=Cloudflare-WARP persistent-keepalive=2m40s public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="`

## Setup IPv4

1. Add Cloudflare WARP's IPv4 address to the WireGuard interface.\
`/ip address add address=172.16.0.2 interface=Cloudflare-WARP`
2. Enable NAT44. The `to-address` should be set to the IPv4 address of the WireGuard interface.\
`/ip firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-WARP to-addresses=172.16.0.2`
3. Add IPv4 route of Cloudflare WARP-to-WARP IPv4 range.\
`/ip route add dst-address=100.64.0.0/10 gateway=Cloudflare-WARP`

### IPv4 port forwarding example

The `dst-address` should be set to the IPv4 address of the WireGuard interface.

To port forward TCP port `8080` of `192.168.1.2`:
```
/ip firewall nat add action=dst-nat chain=dstnat dst-address=172.16.0.2 dst-port=8080 in-interface=Cloudflare-WARP protocol=tcp to-addresses=192.168.1.2
```

## Setup IPv6

If you have native IPv6 already, you probably don't need this.\
It is recommended to just set static IPv6 address to every device that needs IPv6 port forwarding instead of relying on SLAAC so that IPv6 address for port forwarding does not change.

1. Add Cloudflare WARP's IPv6 address to the WireGuard interface.\
`/ipv6 address add address=2606:4700:110:8ced:11b5:d064:abc:ee89/128 interface=Cloudflare-WARP`
2. Add IPv6 ULA in your LAN interface. Make sure the prefix you chosen does not conflict with Cloudflare WARP-to-WARP IPv6 range.\
`/ipv6 address add address=fd00:1234:5678:9abc::/64 advertise=no interface=bridge`
3. Enable NAT66. Yes, I know NAT is bad, awful when we are talking about IPv6, but since Cloudflare WARP only provides a single IPv6 address, it's necessary to use NAT in IPv6. The `to-address` should be set to the IPv6 address of the WireGuard interface.\
`/ipv6 firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-WARP to-address=2606:4700:110:8b7b:2edb:5201:dddd:19fd/128`
4. Add IPv6 route. If you have native IPv6 connectivity, use Cloudflare WARP-to-WARP IPv6 range `fd00::/8`, if you don't have native IPv6, use `::/0`.\
`/ipv6 route add dst-address=::/0 gateway=Cloudflare-WARP`
5. Allow IPv6 firewall to accept packets that are port forwarded.\
`/ipv6 firewall filter set [find action=drop chain=forward in-interface-list="!LAN"] comment="defconf: drop everything else not coming from LAN not DSTNATed" connection-nat-state=!dstnat`

### IPv6 port forwarding example

The `dst-address` should be set to the IPv6 address of the WireGuard interface.

To port forward TCP port `8080` of `fd00:1234:5678:9abc::1`:
```
/ipv6 firewall nat add action=dst-nat chain=dstnat dst-address=2606:4700:110:8b7b:2edb:5201:dddd:19fd/128 dst-port=8080 in-interface=Cloudflare-WARP protocol=tcp to-addresses=fd00:1234:5678:9abc::1/128
```

## Test port forwarding

### Check your MikroTik IP address on Cloudflare virtual network

1. Go to My Team, and Devices.
2. Select the email that you used for your MikroTik router.

For this example, the IP address is `100.96.0.1` and `fd10:ec7e:5e94::1`

### On your device outside of your LAN

1. Download Cloudflare WARP on your device.
2. Login to Cloudflare Zero Trust.
3. Turn on Cloudflare Zero Trust.
4. Try to access `100.96.0.1` and `fd10:ec7e:5e94::1`.