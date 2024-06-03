---
title: 'My ASN Journey: Bring home the IPv6 via WireGuard'
description: How to bring your announced IPv6 prefix to your home router using WireGuard on MikroTik
date: 2024-04-29T19:17:00+08:00
lastmod: 2024-06-03T20:58:00+08:00
tags:
  - ASN
  - VPS
  - WireGuard
  - MikroTik
  - RouterOS
  - IPv6
  - tutorials
---
One of the benefits of IPv6 is that you have a huge number of IP addresses that you can assign to all of your devices.\
Also, unlike IPv4, you don't need to worry about masquerading aka NAT.

This tutorial assumes you have Debian installed on your VPS.\
We will also use MikroTik RouterOS to assign IPv6 addresses to our devices.

## Set up WireGuard on your VPS

### WireGuard configuration

1. Install WireGuard.\
`sudo apt install wireguard`

2. Generate private key.\
`wg genkey | sudo tee /etc/wireguard/private.key`

3. Generate public key.\
`sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key`

Since I'm using an IPv6 only server and I have Cloudflare WARP running at `wg0`, I will use `wg1` in this tutorial. If you don't have any other WireGuard interface running, you can use `wg0`.

4. Create WireGuard configuration.\
`sudo nano /etc/wireguard/wg1.conf`

Here is an example config for WireGuard.

```conf
[Interface]
PrivateKey = <Your private key from step 2>
ListenPort = 51820

[Peer]
PublicKey = <Your client public key>
AllowedIPs = <Your IPv6 address assigned to your dummy1>
```

Example with my IPv6 prefix:

```conf
[Interface]
PrivateKey = <Your private key from step 2>
ListenPort = 51820

[Peer]
PublicKey = <Your client public key>
AllowedIPs = 2a0f:85c1:3b2::/48
```

### IPv6 subnetting

In this example, my IPv6 prefix is `2a0f:85c1:3b2::/48`, we need to assign our WireGuard interface its own `/56` IPv6 prefix from that prefix.\
You can use the [IPv6 Subnet Calculator Tool](https://www.site24x7.com/tools/ipv6-subnetcalculator.html) to choose what prefix you can use.\
Input your IPv6 prefix on that site like `2a0f:85c1:3b2::/48`, and select the number of subnets to "/56 (256) subnets."

In this example, my chosen IPv6 prefix to assign to the WireGuard interface is `2a0f:85c1:3b2:4400::/56`.

### WireGuard Interface configuration

1. Create WireGuard interface configuration.\
`sudo nano /etc/network/interfaces.d/wg1`

Here is an example config for WireGuard interface.

```text
auto wg1
iface wg1 inet6 static
    address <Your chosen IPv6 prefix from your announced IPv6 prefix>
    pre-up ip link add $IFACE type wireguard # Add a WireGuard interface
    pre-up wg setconf $IFACE /etc/wireguard/$IFACE.conf # Set the configuration of the WireGuard interface
    pre-up sysctl net.ipv6.conf.all.forwarding=1 # This will enable IPv6 forwarding on your VPS
    post-down ip link del $IFACE
    post-down sysctl net.ipv6.conf.all.forwarding=0
```

Example with my IPv6 prefix:

```text
auto wg1
iface wg1 inet6 static
    address 2a0f:85c1:3b2:4400::/56
    pre-up ip link add $IFACE type wireguard
    pre-up wg setconf $IFACE /etc/wireguard/$IFACE.conf
    pre-up sysctl net.ipv6.conf.all.forwarding=1
    post-down ip link del $IFACE
    post-down sysctl net.ipv6.conf.all.forwarding=0
```

2. Bring the WireGuard interface up.\
`sudo ifup wg1`

## Set up MikroTik WireGuard

1. Add a new WireGuard interface.\
`/interface wireguard add mtu=1420 name=IPv6-Tunnel`

2. Get WireGuard public key. The output of the public key here is the one you will add to the client public key on your VPS.\
`/interface wireguard print`

3. Add a WireGuard peer to connect to your VPS.\
If your VPS has an IPv4 address, you can use its IPv4 address as the endpoint address. If it's an IPv6 only VPS, the endpoint address can be the IPv6 address of the VPS if you have native IPv6 connectivity at home, or its Cloudflare WARP IPv4 address.\
`/interface wireguard peers add allowed-address=::/0 endpoint-address=<Your VPS IP address> endpoint-port=51820 interface=IPv6-Tunnel persistent-keepalive=2m public-key="<Your VPS public key>"`

## Set up IPv6 on MikroTik

The MikroTik WireGuard interface must also have its own IPv6 address.\
Since the IPv6 address of our VPS WireGuard interface is `2a0f:85c1:3b2:4400::/56`, I chose the prefix `2a0f:85c1:3b2:4400::1/56` as our MikroTik's IPv6 address.

### WAN side

1. Add your chosen IPv6 prefix to the WireGuard interface.\
`/ipv6 address add address=<Your chosen MikroTik IPv6 prefix from your announced IPv6 prefix> interface=IPv6-Tunnel`\
Example with my IPv6 prefix:\
`/ipv6 address add address=2a0f:85c1:3b2:4400::1/56 interface=IPv6-Tunnel`

2. Add IPv6 route that goes to your VPS's WireGuard interface.\
`/ipv6 route add dst-address=::/0 gateway=<IPv6 address of VPS WireGuard interface>`\
Example with my IPv6 prefix:\
`/ipv6 route add dst-address=::/0 gateway=2a0f:85c1:3b2:4400::`

### LAN side

Now we need to assign our devices its own IPv6 address from your prefix, but it needs to be a `/64` to be given via SLAAC.\
You can use the [IPv6 Subnet Calculator Tool](https://www.site24x7.com/tools/ipv6-subnetcalculator.html) to choose what prefix you can use.\
Input your IPv6 prefix on that site like `2a0f:85c1:3b2:4400::/56`, and select the number of subnets to "/64 (256) subnets."

In this example, my chosen IPv6 prefix to be given to our devices is `2a0f:85c1:3b2:4444::/64`.

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just on the LAN. Take note of the MTU. Since the default MTU of WireGuard is 1420, set the MTU of ND to 1420 so that the packets don't fragment.\
`/ipv6 nd set [ find default=yes ] interface=bridge mtu=1420`

2. Add your chosen IPv6 prefix to your LAN interface.\
`/ipv6 address add address=<Your chosen /64 IPv6 prefix from your MikroTik IPv6 prefix> advertise=yes interface=bridge`\
Example with my IPv6 prefix:\
`/ipv6 address add address=2a0f:85c1:3b2:4444::/64 advertise=yes interface=bridge`

Your devices will now receive their own IPv6 address from your own IPv6 prefix.