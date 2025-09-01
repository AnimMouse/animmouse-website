---
title: Setup Cloudflare WARP Connector using WireGuard
description: Extract Cloudflare WARP Connector WireGuard configuration for use in WireGuard
date: 2025-09-01T08:37:00+08:00
tags:
  - Cloudflare
  - WireGuard
  - IPv6
  - tutorials
---
Cloudflare WARP is an overlay network just like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard.

Finally, a free site-to-site VPN from Cloudflare.

Because Cloudflare WARP uses WireGuard, we can run Cloudflare WARP Connector on any devices that can run WireGuard.

## Cloudflare Zero Trust settings

### Cloudflare WARP-to-WARP

1. Go to [Settings, and Network](https://one.dash.cloudflare.com/?to=/:account/settings/network).
2. Enable Proxy.
3. Check UDP and ICMP.
4. Enable "Allow WARP to WARP connection".

### Let Cloudflare assign the WARP-to-WARP IPv4 range to devices

Instead of getting the same IP address of `172.16.0.2` to every device, we instead enable "Override local interface IP" so that devices get their own unique IP from `100.96.0.0/12`.

1. Go to [Settings, and WARP Client](https://one.dash.cloudflare.com/?to=/:account/settings/devices).
2. Enable "Override local interface IP".

### Configure Split Tunneling

This allows Cloudflare WARP-to-WARP traffic to pass though the WireGuard instead of getting handled as local traffic.

1. Go to [Settings, and WARP Client](https://one.dash.cloudflare.com/?to=/:account/settings/devices).
2. Click [Default profile, and configure](https://one.dash.cloudflare.com/?to=/:account/settings/devices/profile-settings/default).
3. Make sure split tunnels is set to Exclude IPs and domains.
4. Click ["Manage" on Split Tunnels](https://one.dash.cloudflare.com/?to=/:account/settings/devices/profile-settings/default/split-tunnels/exclude/exclude_office_ips_disabled).
5. Remove IP range `100.64.0.0/10`.
6. Add IP range `100.64.0.0/11` and `100.112.0.0/12`. (Optional)

### Create WARP Connector tunnel

1. Go to [Networks, and then Tunnels](https://one.dash.cloudflare.com/?to=/:account/networks/tunnels).
2. Click [Create a tunnel](https://one.dash.cloudflare.com/?to=/:account/networks/tunnels/new).
3. Select [WARP Connector](https://one.dash.cloudflare.com/?to=/:account/networks/tunnels/add/warp).
4. Make sure all prerequisites are enabled, and then next step.
5. Name your tunnel, and then Create tunnel.
6. Copy the WARP Connector token at step 3 that starts with `eyJhIjoi`, and then click next step.
7. Click Return to Tunnels.

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
Address = 2606:4700:cf1:1000::1/64, 100.96.0.1/12
DNS = 2606:4700:4700::1111, 2606:4700:4700::1001, 1.1.1.1, 1.0.0.1
MTU = 1420

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0, 0.0.0.0/0
Endpoint = 162.159.193.1:2408
#Endpoint = [2606:4700:100::a29f:c102]:2408
```

Now you can use that WireGuard configuration to any devices that can use WireGuard in order to connect to Cloudflare Zero Trust.