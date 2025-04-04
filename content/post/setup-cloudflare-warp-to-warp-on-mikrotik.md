---
title: Setup Cloudflare WARP-to-WARP on MikroTik
description: Setup Cloudflare Zero Trust and port forwarding on RouterOS
date: 2023-08-27T00:16:00+08:00
lastmod: 2025-04-05T23:52:00+08:00
tags:
  - Cloudflare
  - RouterOS
  - MikroTik
  - WireGuard
  - IPv6
  - tutorials
---
Cloudflare WARP-to-WARP is an overlay network just like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard.

Because Cloudflare WARP uses WireGuard, we can run Cloudflare WARP on MikroTik and port forward on our virtual network at Cloudflare.

Update: A new tutorial that uses WARP Connector instead is [here](../setup-cloudflare-warp-connector-on-mikrotik/). It works the same but you don't need to port forward anymore.

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
5. Remove IP range `100.64.0.0/10` and `fd00::/8`.
6. Add IP range `100.64.0.0/11` and `100.112.0.0/12`. (Optional)

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
Address = 2606:4700:cf1:1000::1/128
Address = 100.96.0.1/32
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

1. Add a new WireGuard interface.\
`/interface wireguard add mtu=1420 name=Cloudflare-WARP private-key="your_private_key"`
2. Add WireGuard peer to connect to Cloudflare WARP. For Zero Trust, `162.159.193.1` should be the endpoint to reduce latency.[^1] Persistent keepalive is enabled so that the tunnel will not timeout when not in use.\
`/interface wireguard peers add allowed-address=0.0.0.0/0,::/0 endpoint-address=162.159.193.1 endpoint-port=2408 interface=Cloudflare-WARP name=Cloudflare-PoP persistent-keepalive=1m public-key="bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo="`

## Setup IPv4

1. Add Cloudflare WARP's IPv4 address to the WireGuard interface. Replace `/32` subnet to `/12` so that a dynamic IPv4 route will automatically be created.\
`/ip address add address=100.96.0.1/12 interface=Cloudflare-WARP`
2. Enable NAT44. The `to-address` should be set to the IPv4 address of the WireGuard interface.\
`/ip firewall nat add action=src-nat chain=srcnat out-interface=Cloudflare-WARP to-address=100.96.0.1`

### IPv4 port forwarding example

The `dst-address` should be set to the IPv4 address of the WireGuard interface.

To port forward TCP port `8080` of `192.168.1.2`:
```
/ip firewall nat add action=dst-nat chain=dstnat dst-address=100.96.0.1 dst-port=8080 in-interface=Cloudflare-WARP protocol=tcp to-address=192.168.1.2
```

## Setup IPv6

It is recommended to just set a static IPv6 address to every device that needs IPv6 port forwarding instead of relying on SLAAC so that the IPv6 address for port forwarding does not change.

1. Add Cloudflare WARP's IPv6 address to the WireGuard interface. Replace `/128` subnet to `/64` so that a dynamic IPv6 route will automatically be created.\
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

## Test port forwarding

### Check your MikroTik router's IP address on the Cloudflare virtual network

1. Go to My Team, and Devices.
2. Select the device name besides the email that you used for your MikroTik router.

For this example, the IP addresses are `100.96.0.1` and `2606:4700:cf1:1000::1`

### On your device outside your LAN

1. Download Cloudflare WARP on your device.
2. Login to Cloudflare Zero Trust.
3. Turn on Cloudflare Zero Trust.
4. Try to ping and access the server that is port forwarded at `100.96.0.1` and `2606:4700:cf1:1000::1`.

## DNS hostnames

If you own a domain name, you can use a subdomain that is pointed at `100.96.0.1` and `2606:4700:cf1:1000::1` since the IP allocation on the Cloudflare virtual network is static.

[^1]: [WARP with firewall: WARP ingress IP](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/deployment/firewall/#warp-ingress-ip)