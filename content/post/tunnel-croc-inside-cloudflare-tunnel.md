---
title: Tunnel Croc inside Cloudflare Tunnel
description: How to tunnel Croc file transfer on Cloudflare Tunnel
date: 2023-03-03T14:36:06+08:00
tags:
  - Cloudflare
  - tutorials
---
[Croc](https://github.com/schollz/croc) is a tool that allows any 2 computers to simply and securely transfer files and folders.\
Most of the time, the 2 computers are behind NAT, and does not have IPv6, so file transfers uses schollz's own funded public relay and that costs him $40-50/month.[^1]\
We can run our own relay and host it on VPS, but that also cost money just for hosting a relay. We instead try to use Cloudflare Tunnel to allow 2 computers to discover each other and transfer files using Cloudflare as relay.

## Sending side

Croc requires a minimum of 2 ports for relay,[^2] so we need 2 ingress for each port.

### Download and install cloudflared

1. Download [cloudflared](https://github.com/cloudflare/cloudflared/releases/latest).
2. Authenticate cloudflared.\
`cloudflared tunnel login`
3. Create a tunnel.\
`cloudflared tunnel create croc-tunnel`

#### Setup Cloudflare Tunnel

1. Create a `config.yaml` file.
```yaml
tunnel: deadbeef-1234-4321-abcd-123456789abc # Put your tunnel ID here
credentials-file: /path/to/cloudflare-tunnel-credential.json

ingress:
  - hostname: croc-coms.example.com # Put your domain name here
    service: tcp://localhost:9009 # Croc port for communication
  - hostname: croc-data.example.com
    service: tcp://localhost:9010 # Croc port for data transfer
  - service: http_status:404
```

2. Run Cloudflare Tunnel.\
`cloudflared tunnel run`

#### Setup Croc

The `--local` flag will make Croc a sender and relay at the same time.\
The `--code` flag stops Croc from making a new code everytime, setting it to `123456`.\
The `--ports` flag will specify what ports do Croc will run. Since Croc will try to use ports 9009-9013, we need to set it to only use 2 ports.

1. Send file using Croc.\
`croc --local send --code 123456 --ports 9009,9010 file.ext`

## Receiving side

The receiving side requires cloudflared because Cloudflare only tunnels HTTP, not TCP that Croc need, so in order to tunnel TCP, cloudflared must be present at the receiving side.[^3]

1. Download [cloudflared](https://github.com/cloudflare/cloudflared/releases/latest).

2. Connect communication port to Cloudflare Tunnel using cloudflared access.\
`cloudflared access tcp --hostname croc-coms.example.com --url localhost:9009`

   a. For Linux, you can use `nohup` for background execution.\
   `nohup cloudflared access tcp --hostname croc-coms.example.com --url localhost:9009 &`

3. Connect data port to Cloudflare Tunnel using cloudflared access.\
`cloudflared access tcp --hostname croc-data.example.com --url localhost:9010`

The `--ip` flag will specify which IP to connect, since Cloudflare Tunnel exposes the tunnel on localhost, we connect to localhost.

4. Receive file using Croc.\
`croc --local --ip 127.0.0.1:9009 123456`

[^1]: [This project needs your help again · Issue #453](https://github.com/schollz/croc/issues/453)
[^2]: [schollz/croc: Self-host relay](https://github.com/schollz/croc#self-host-relay)
[^3]: [Arbitrary TCP · Cloudflare Zero Trust docs](https://developers.cloudflare.com/cloudflare-one/applications/non-http/arbitrary-tcp/#connect-from-a-client-machine)