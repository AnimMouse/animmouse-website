---
title: SOCKS5 Proxy on GitHub Actions
date: 2021-12-07T21:52:43+08:00
categories:
  - projects
---
## GitHub Actions Hackathon 2021

Since GitHub Actions is an IaaS, and Actions Hackathon 2021 allows Wacky Wildcards, I wonder if I can use it as a proxy and view the internet from the perspective of GitHub's servers. So I created a proof of concept SOCKS5 proxy hosted on GitHub Actions.

As GitHub Actions runners are firewalled from incoming connections, what I did is connect to it through Cloudflare Tunnel. And as Cloudflare Tunnel can't tunnel TCP connections (we can use Ngrok but that's for another story), we tunnel SOCKS5 through websockets using Chisel.

Here you can see that I'm browsing the internet using Microsoft's IP address.

![IP address check 1](IP-address-check-1.png)\
![IP address check 2](IP-address-check-2.png)\
![IP address check 3](IP-address-check-3.png)\
![IP address check 4](IP-address-check-4.png)

Here you can see a speed test from my 45 mbps internet connection.

![Speed test](Speed-test.png)

This action can also be used as a VPN.