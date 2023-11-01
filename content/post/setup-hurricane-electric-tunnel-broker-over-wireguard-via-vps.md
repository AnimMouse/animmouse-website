---
title: Setup Hurricane Electric tunnel broker over WireGuard via VPS
description: Setup Hurricane Electric IPv6 6in4 tunnel broker behind CGNAT
date: 2023-11-01T20:29:00+08:00
tags:
  - WireGuard
  - VPS
  - IPv6
  - tutorials
---
Hurricane Electric provides an IPv6 tunnel broker via 6in4 for those who don't have IPv6, but the problem is, 6in4 aka protocol 41 SIT (Simple Internet Transition) does not work behind NAT (or worse CGNAT) so we need to rent a VPS that allows us to get Hurricane Electric IPv6 connectivity and tunnel it though WireGuard that we can pass though NAT.

## Get VPS

Get a VPS that is nearest to Hurricane Electric PoP that is nearest to you. In this example, I live in the Philippines, and my nearest Hurricane Electric PoP is Singapore, so I will rent a VPS on Singapore.

VPS should have Ubuntu 22.04 and up with Netplan installed. (Netplan should come preinstalled.)

## Setup Hurricane Electric IPv6 tunnel

1. Login to [tunnelbroker.net](https://tunnelbroker.net).
2. Click Create Regular Tunnel under User Functions.
3. Set IPv4 Endpoint to your VPS's IPv4 address.
4. Select the location that is nearest to your VPS. In this example, I will select Singapore.
5. Click Create Tunnel.
6. On Routed /48, click Assign /48. We need `/48` for WireGuard.
7. Take note of your `/48` prefix, for this example, it is `2001:470:eddc::/48`

### Get Netplan configuration

1. Click Example Configurations.
2. On Select Your OS dropbox, select Linux (netplan 0.103+).

The Netplan configuration will show like this:
```yaml
network:
  version: 2
  tunnels:
    he-ipv6:
      mode: sit
      remote: 216.218.221.42
      local: your_local_address
      addresses:
        - "2001:470:35:67f::2/64"
      routes:
        - to: default
          via: "2001:470:35:67f::1"
```

## Setup VPS

### Install Netplan configuration on VPS

1. Create new Netplan configuration `sudo nano /etc/netplan/he.yaml`
2. Paste the configuration file from Hurricane Electric, and save and exit by pressing Ctrl + X.
3. Apply Netplan configuration. `sudo netplan apply`

### Setup WireGuard

1. Install WireGuard. `sudo apt update && sudo apt install wireguard`
2. Generate private key. `wg genkey | sudo tee /etc/wireguard/private.key`
3. Generate public key. `sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key`
4. Create WireGuard configuration. `sudo nano /etc/wireguard/wg0.conf`

Paste this WireGuard configuration and edit.
```conf
[Interface]
PrivateKey = your_private_key # Put your private key here from step 2
Address = 2001:470:eddc::/48 # Your /48 prefix from Hurricane Electric
ListenPort = 51820
MTU = 1420
PostUp = sysctl net.ipv6.conf.all.forwarding=1 # This will enable IPv6 forwarding on your VPS
PostUp = ufw route allow in on wg0 out on eth0 # This will allow your firewall to allow IP forwarding on your VPS
PreDown = sysctl net.ipv6.conf.all.forwarding=0
PreDown = ufw route delete allow in on wg0 out on eth0

[Peer]
PublicKey = client_public_key # Put your client's public key here
AllowedIPs = 2001:470:eddc::/48 # Allow clients to access your /48 prefix from Hurricane Electric
```

5. Enable WireGuard server. `sudo systemctl enable wg-quick@wg0.service`
6. Start WireGuard server. `sudo systemctl start wg-quick@wg0.service`
7. Check if WireGuard server is running. `sudo systemctl status wg-quick@wg0.service`

## Setup client

### Get IPv6 prefix

Hurricane Electric gives us `/48` subnet, which we can divide into 65,536 `/64` subnets. Since we got `2001:470:eddc::/48`, I chosen the prefix `2001:470:eddc:4::/64`.

### Setup WireGuard

1. Install WireGuard on your client.
2. Generate private and public key.
3. Create WireGuard configuration.

Paste this WireGuard configuration and edit.
```conf
[Interface]
PrivateKey = your_private_key # Put your client private key here from step 2
Address = 2001:470:eddc:4::/64 # Your chosen prefix.
ListenPort = 51820
MTU = 1420

[Peer]
PublicKey = vps_public_key # Put your VPS's public key here.
AllowedIPs = 2000::/3 # Allow us to access the whole IPv6 internet.
Endpoint = 192.0.2.1:51820 # Put your VPS's IPv4 address here.
```