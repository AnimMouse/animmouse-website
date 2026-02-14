---
title: 'My ASN Journey: Bring home the IPv6 via WireGuard'
description: How to bring your announced IPv6 prefix to your home router using WireGuard on MikroTik
date: 2024-04-29T19:17:00+08:00
lastmod: 2026-02-14T21:08:00+08:00
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

## IP Address Management (IPAM)

The implementation requires the allocation of two distinct IPv6 blocks from your assigned range: a Transit Prefix (or Link Prefix) to facilitate the WireGuard point-to-point connection, and a Delegated Prefix (or Routed Prefix) for end-device address assignment.

In this configuration, we use a prefix of `2a0a:6044:accd::/48` to derive the following subnets:
* Transit Prefix: `2a0a:6044:accd:1::/64`
* Delegated Prefix: `2a0a:6044:accd:100::/56`

### Subnet Planning

To calculate your own unique ranges, you may utilize an [IPv6 Subnet Calculator Tool].

1. Input your Base Prefix: Enter your assigned range (e.g., `2a0a:6044:accd::/48`).
2. Identify the Transit Range: Select a subnet size of /64 (yielding 65,536 possible subnets) and choose one for the tunnel link.
3. Identify the Delegated Range: Select a subnet size of /56 (yielding 256 possible subnets) to assign to the client's internal network.

### Assignment of IP Address

Within the designated Transit Prefix, individual addresses must be assigned to both the server (VPS) and the client to establish the point-to-point connection.

In this implementation, we utilize the first two available addresses from the /64 transit range:

* Server (VPS) Interface Address: `2a0a:6044:accd:1::1/64`
* Client Interface Address: `2a0a:6044:accd:1::2/64`

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
PublicKey = <Your client public key (from the tutorial later on)>
AllowedIPs = <Client Interface Address using /128 prefix>, <Delegated Prefix>
```

Example with my IPv6 prefix:

```conf
[Interface]
PrivateKey = <Your private key from step 2>
ListenPort = 51820

[Peer]
PublicKey = <Your client public key (from the tutorial later on)>
AllowedIPs = 2a0a:6044:accd:1::2/128, 2a0a:6044:accd:100::/56
```

### WireGuard Interface configuration

1. Create WireGuard interface configuration.\
`sudo nano /etc/network/interfaces.d/wg1`

Here is an example config for WireGuard interface.

```text
auto wg1
iface wg1 inet6 static
    address <Server Interface Address>
    pre-up ip link add $IFACE type wireguard # Add a WireGuard interface
    pre-up wg setconf $IFACE /etc/wireguard/$IFACE.conf # Set the configuration of the WireGuard interface
    pre-up sysctl net.ipv6.conf.all.forwarding=1 # This will enable IPv6 forwarding on your VPS
    post-up ip -6 route add <Delegated Prefix> dev $IFACE # This will add route to your delegated prefix
    pre-down ip -6 route del <Delegated Prefix> dev $IFACE
    post-down ip link del $IFACE
    post-down sysctl net.ipv6.conf.all.forwarding=0
```

Example with my IPv6 prefix:

```text
auto wg1
iface wg1 inet6 static
    address 2a0a:6044:accd:1::1/64
    pre-up ip link add $IFACE type wireguard
    pre-up wg setconf $IFACE /etc/wireguard/$IFACE.conf
    pre-up sysctl net.ipv6.conf.all.forwarding=1
    post-up ip -6 route add 2a0a:6044:accd:100::/56 dev $IFACE
    pre-down ip -6 route del 2a0a:6044:accd:100::/56 dev $IFACE
    post-down ip link del $IFACE
    post-down sysctl net.ipv6.conf.all.forwarding=0
```

2. Bring the WireGuard interface up.\
`sudo ifup wg1`

#### For VPS with UFW firewall

If your VPS has a UFW firewall, add this below the `post-up`:

```
    post-up ufw allow 51820 # Allow WireGuard port
    post-up ufw route allow in on $IFACE out on <Your VPS network interface> # Allow site-to-internet routing
    post-up ufw route allow in on $IFACE out on $IFACE # Allow site-to-site routing
    pre-down ufw route delete allow in on $IFACE out on $IFACE
    pre-down ufw route delete allow in on $IFACE out on <Your VPS network interface>
    pre-down ufw delete allow 51820
```

## Set up MikroTik WireGuard

1. Add a new WireGuard interface.\
`/interface wireguard add mtu=1420 name=IPv6-Tunnel`

2. Get WireGuard public key. The output of the public key here is the one you will add to the client public key on your VPS.\
`/interface wireguard print`

3. Add a WireGuard peer to connect to your VPS.\
If your VPS has an IPv4 address, you can use its IPv4 address as the endpoint address. If it's an IPv6 only VPS, the endpoint address can be the IPv6 address of the VPS if you have native IPv6 connectivity at home, or its Cloudflare WARP IPv4 address.\
`/interface wireguard peers add allowed-address=::/0 endpoint-address=<Your VPS IP address> endpoint-port=51820 interface=IPv6-Tunnel persistent-keepalive=2m public-key="<Your VPS public key>"`

### WAN side

1. Add your chosen IPv6 prefix to the WireGuard interface.\
`/ipv6 address add address=<Client Interface Address> interface=IPv6-Tunnel`\
Example with my IPv6 prefix:\
`/ipv6 address add address=2a0a:6044:accd:1::2/64 interface=IPv6-Tunnel`

2. Add IPv6 route that goes to your VPS's WireGuard interface.\
`/ipv6 route add dst-address=::/0 gateway=<Server Interface Address>`\
Example with my IPv6 prefix:\
`/ipv6 route add dst-address=::/0 gateway=2a0a:6044:accd:1::1`

### LAN side

Now we need to assign our devices its own IPv6 address from your prefix, but it needs to be a `/64` to be given via SLAAC.\
You can use the [IPv6 Subnet Calculator Tool] to choose what prefix you can use.\
Input your delegated IPv6 prefix on that site like `2a0a:6044:accd:100::/56`, and select the number of subnets to "256 Subnets (/64)."

In this example, my chosen IPv6 prefix to be given to our devices is `2a0a:6044:accd:100::/64`.

1. Set the Neighbor Discovery to the correct interface. By default, Neighbor Discovery is enabled for all interfaces, but it's better to run it just on the LAN. Take note of the MTU. Since the default MTU of WireGuard is 1420, set the MTU of ND to 1420 so that the packets don't fragment.\
`/ipv6 nd set [ find default=yes ] interface=bridge mtu=1420`

2. Add your chosen IPv6 prefix to your LAN interface.\
`/ipv6 address add address=<Delegated IPv6 prefix in /64> advertise=yes interface=bridge`\
Example with my IPv6 prefix:\
`/ipv6 address add address=2a0a:6044:accd:100::/64 advertise=yes interface=bridge`

Your devices will now receive their own IPv6 address from your own IPv6 prefix.

[IPv6 Subnet Calculator Tool]: https://ipv6.tools/#eyJwYWdlIjoic3VicyIsInZhbHMiOnt9fQ==