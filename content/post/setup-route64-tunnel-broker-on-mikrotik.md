---
title: Setup Route64 tunnel broker on MikroTik
description: Setup Route64 IPv6 WireGuard tunnel on RouterOS
date: 2023-11-01T01:45:00+08:00
tags:
  - RouterOS
  - MikroTik
  - IPv6
  - tutorials
---
## Setup Route64

### Create IPv6 WireGuard tunnel

1. Login to Route64 manager.
2. Go to IPv6 Tunnelbroker, and Add new tunnelbroker.
3. Choose your nearest PoP on Interface dropbox.
4. On Tunnel type dropbox, choose Wireguard4.
5. Enter your IP address on Remote endpoint.
6. Click Create Tunnelbroker Service.

### Get WireGuard configuration

1. Go to IPv6 Tunnelbroker, and List all tunnels.
2. On your tunnel, click the meatballs menu icon and click Show Config.

The WireGuard configuration will show like this:
```conf
[Interface]
PrivateKey = your_private_key
Address = 2a11:6c7:f03:153::2/64

[Peer]
PublicKey = FkVCzA3bhSrqOUhXNxVHDXSLDvWHUa7BGj75uuh85TE=
AllowedIPs = ::/1, 8000::/1
Endpoint = 165.140.142.113:58140
PersistentKeepAlive = 30
```

### Get IPv6 subnet

The IPv6 subnet is the one that you will assign on your devices connected to the router.

1. Go to IPv6 Tunnelbroker, and List IP subnets.
2. On your tunnel, the subnet will appear, in this case it is `2a11:6c7:2001:5300::/56`.

## Setup MikroTik WireGuard

1. Add new WireGuard interface.\
`/interface wireguard add mtu=1420 name=Route64 private-key="your_private_key"`
2. Add WireGuard peer to connect to Route64.\
`/interface wireguard peers add allowed-address=::/1,8000::/1 endpoint-address=165.140.142.113 endpoint-port=58140 interface=Route64 persistent-keepalive=30s public-key="FkVCzA3bhSrqOUhXNxVHDXSLDvWHUa7BGj75uuh85TE="`

## Setup IPv6

### WAN side

1. Add Route64 IPv6 address to the WireGuard interface.\
`/ipv6 address add address=2a11:6c7:f03:153::2/64 interface=Route64`
2. Add IPv6 route that goes to the Route64 WireGuard interface.\
`/ipv6 route add dst-address=2000::/3 gateway=Route64`

### LAN side

Route64 gives us `/56` subnet, which we can divide into 256 `/64` subnets. Since we got `2a11:6c7:2001:5300::/56`, I chosen the prefix `2a11:6c7:2001:5304::/64` to be given via SLAAC.

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just at LAN. Take note of the MTU, since the default MTU of WireGuard is 1420, set the MTU of ND to 1420 so that the packets don't fragment.\
`/ipv6 nd set [ find default=yes ] interface=bridge mtu=1420`
2. Add Route64 IPv6 subnet address to your LAN interface.\
`/ipv6 address add address=2a11:6c7:2001:5304::/64 advertise=yes interface=bridge`

## Testing

1. Try to ping your Route64 tunnel endpoint. If your address is `2a11:6c7:f03:153::2/64`, then your tunnel endpoint is `2a11:6c7:f03:153::1`.
2. Try to ping an IPv6 server or use [test-ipv6.com](https://test-ipv6.com).