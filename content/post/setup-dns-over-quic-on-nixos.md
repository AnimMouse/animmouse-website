---
title: Setup DNS over QUIC on NixOS
description: Install dnsproxy and use DNS over QUIC on NixOS
date: 2024-04-17T00:23:00+08:00
tags:
  - DNS
  - Linux
  - tutorials
---
## Install DNS Proxy
Add dnsproxy to your `environment.systemPackages` like this:
```nix
environment.systemPackages = with pkgs; [
  dnsproxy
];
```

## Use a local DNS server
```nix
networking.nameservers = [ "127.0.0.1" "::1" ];
networking.networkmanager.dns = "none";
```

## Create a systemd service to run DNS Proxy
```nix
systemd.services.dnsproxy = {
  description = "dnsproxy";
  serviceConfig.ExecStart = "${pkgs.dnsproxy}/bin/dnsproxy -l 127.0.0.1 -u quic://dns.nextdns.io";
  wantedBy = [ "multi-user.target" ];
};
```
If you have a local DNS server at `192.168.1.1`, you can specify `home.arpa` to resolve at `192.168.1.1`. Also enable cache.
```nix
systemd.services.dnsproxy = {
  description = "dnsproxy";
  serviceConfig.ExecStart = "${pkgs.dnsproxy}/bin/dnsproxy -l 127.0.0.1 -u quic://dns.nextdns.io -u [/home.arpa/]192.168.1.1 -b 192.168.1.1 --cache --cache-optimistic";
  wantedBy = [ "multi-user.target" ];
};
```