---
title: Setup DNS over QUIC on Windows
description: Install dnsproxy and use DNS over QUIC on Windows
date: 2024-04-17T00:12:00+08:00
lastmod: 2025-09-14T04:28:00+08:00
tags:
  - DNS
  - Windows
  - tutorials
---
DNS over QUIC (DoQ) is a new protocol for encrypted DNS queries that uses QUIC which is now standardized on RFC 9250.

Unlike DNS over TLS (DoT), DoQ is faster as it uses UDP instead of TCP.\
Unlike DNS over HTTPS and HTTPS/3 (DoH and DoH3), DoQ does not attempt to hide itself to censors so this is good if you don't have censorship in your country.

## Install DNS Proxy
1. Download [dnsproxy](https://github.com/AdguardTeam/dnsproxy) [here](https://github.com/AdguardTeam/dnsproxy/releases/latest) for Windows.
2. Extract the archive.
3. Create a new folder in Program Files named "dnsproxy".
4. Move `dnsproxy.exe` to `C:\Program Files\dnsproxy`.

## Create new task
1. Open Task Scheduler.
2. Create Task.
3. Name the task "DNS Proxy"
4. Under "Security options", select "Run whether user is logged on or not".
5. Select "Do not store password".
6. Under "Configure for:", select Windows 10.

### Triggers
1. Go to the Triggers tab.
2. Click "New".
3. Under "Begin the task:", select "At startup".
4. Click OK.

### Actions
1. Go to the Actions tab.
2. Click "New".
3. At the "Program/script:" text field, enter `"C:\Program Files\dnsproxy\dnsproxy.exe"`.
4. At the "Add arguments (optional):" text field, this is where your dnsproxy config goes.\
Here is an example config that uses NextDNS's DNS-over-QUIC resolver:\
Note that you need to specify a bootstrap server since by default, dnsproxy uses a system-provided DNS server, which is the dnsproxy itself `127.0.0.1` which causes a loop.
```
-l 127.0.0.1 -l ::1 -u quic://dns.nextdns.io -b 1.1.1.1 -b 2606:4700:4700::1111
```
If you have local DNS server at `192.168.1.1`, you can specify `home.arpa` to resolve at `192.168.1.1`. Also enable cache and EDNS.
```
-l 127.0.0.1 -l ::1 -u quic://dns.nextdns.io -u [/home.arpa/]192.168.1.1 -b 1.1.1.1 -b 2606:4700:4700::1111 --cache --cache-optimistic --edns
```
5. Click OK.

### Conditions
1. Go to the Condtions tab.
2. Uncheck "Start the task only if the computer is on AC power".

### Settings
1. Go to the Settings tab.
2. Check "Run task as soon as possible after a scheduled start is missed".
3. Check "If the task fails, restart every:".
4. Uncheck "Stop the task if it runs longer than:".

### Create and run the task
1. Click OK to create the task.
2. Click Run to run DNS proxy.

## Allow NCSI to use localhost DNS
Network Connectivity Status Indicator is a feature in Windows that determines if you have an internet connection or not. By default, NCSI will restrict DNS lookups to the interface it is currently probing on. By enabling "Use global DNS", NCSI can now use the loopback interface for checking internet connectivity.

1. Open gpedit.msc
2. Go to Computer Configuration > Administrative Templates > Network > Network Connectivity Status Indicator
3. Enable the "Specify global DNS" setting.
4. Check "Use global DNS" checkbox.
5. Click OK.

## Setup Windows DNS to use DNS Proxy

### IPv4
1. Change the "Preferred DNS server" setting on your network interface' IPv4 to `127.0.0.1`.
2. Leave the "Alternate DNS server" setting to blank.

### IPv6
1. Change the "Preferred DNS server" setting on your network interface' IPv6 to `::1`.
2. Leave the "Alternate DNS server" setting to blank.