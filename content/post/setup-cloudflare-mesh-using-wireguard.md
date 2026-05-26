---
title: Setup Cloudflare Mesh using WireGuard
description: Extract Cloudflare Mesh (formerly WARP Connector) WireGuard configuration
date: 2025-09-01T08:37:00+08:00
lastmod: 2026-05-27T03:11:00+08:00
tags:
  - Cloudflare
  - WireGuard
  - IPv6
  - tutorials
---
[Cloudflare Mesh](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-mesh/) (formerly WARP Connector) is an overlay network like ZeroTier and Tailscale but instead of peer-to-peer, you connect to the nearest Cloudflare PoP using WireGuard just like NordVPN Meshnet.

Finally, a free site-to-site VPN from Cloudflare.

Because Cloudflare Mesh uses WireGuard, we can run Cloudflare Mesh nodes on any devices that can run WireGuard.

## Cloudflare Zero Trust settings

### Cloudflare One traffic

1. Go to [Team & Resources → Devices → Management].
2. Under "Mesh connectivity", enable "Allow all Cloudflare One traffic to reach enrolled devices".

### Let Cloudflare assign the CGNAT IPv4 range to devices

Instead of getting the same IP address of `172.16.0.2` to every device, we instead enable "Assign a unique IP address to each device" so that devices get their own unique IP from `100.96.0.0/12`.

1. Go to [Team & Resources → Devices → Management].
2. Under "Global device client settings", enable "Assign a unique IP address to each device".

### Configure Split Tunneling

This allows the Cloudflare Mesh traffic to pass though the WireGuard instead of getting handled as local traffic.

1. Go to [Team & Resources → Devices → Device profiles].
2. Click [Default profile → Edit](https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/device-profiles/default).
3. Make sure split tunnels is set to Exclude IPs and domains.
4. Click ["Manage" on Split Tunnels](https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/device-profiles/default/split-tunnels/exclude/exclude_office_ips_disabled).
5. Remove IP range `100.64.0.0/10`.
6. Add IP range `100.64.0.0/11` and `100.112.0.0/12`. (Optional)

### Create a separate device profile for the Cloudflare Mesh nodes

To ensure that Cloudflare Mesh nodes will only get a WireGuard configuration instead of a MASQUE configuration.

1. Go to [Team & Resources → Devices → Device profiles].
2. Duplicate the Default profile.
3. Name the profile "Cloudflare Mesh".
4. On the "Build an expression", set\
"User email is `warp_connector@<your-team-name>.cloudflareaccess.com`".
5. Make sure the Device tunnel protocol is set to WireGuard.
6. Click "Save profile".

### Create Cloudflare Mesh node

1. Go to [Networking → Mesh](https://dash.cloudflare.com/?to=/:account/mesh).
2. Click [Add node](https://dash.cloudflare.com/?to=/:account/mesh/add).
3. Name your node, and then Continue.
4. Copy the token at "Register & connect" that starts with `eyJhIjoi` and ends with `In0=`, and then click "I'll connect later".
5. Click "View node details".

## Generate Cloudflare Mesh WireGuard configuration

1. Open a terminal with Docker installed. It is recommended to use GitHub Codespaces if you have a GitHub account.
2. Using [wgcf-connector](https://github.com/AnimMouse/wgcf-connector), enter this command in terminal, replacing `<token>` with the token you copied earlier that starts with `eyJhIjoi` and ends with `In0=`.

```sh
docker run --rm -v $(pwd):/app/output ghcr.io/animmouse/wgcf-connector <token>
```

The program will output a file wgcf-connector-<registration_id>.conf in your current working directory with contents like this:

```conf
# Registration ID: 00000000-0000-0000-0000-000000000000
# Organization: organization_name
[Interface]
PrivateKey = your_private_key
Address = 2606:4700:cf1:1000::1/128, 100.96.0.1/32
DNS = 2606:4700:4700::1111, 2606:4700:4700::1001, 1.1.1.1, 1.0.0.1
MTU = 1420

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = ::/0, 0.0.0.0/0
Endpoint = 162.159.193.1:2408
#Endpoint = [2606:4700:100::a29f:c102]:2408
```

Now you can use that WireGuard configuration to any devices that can use WireGuard in order to connect to your Cloudflare Mesh private network.

[Team & Resources → Devices → Management]: https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/management
[Team & Resources → Devices → Device profiles]: https://dash.cloudflare.com/?to=/:account/one/team-resources/devices/profiles