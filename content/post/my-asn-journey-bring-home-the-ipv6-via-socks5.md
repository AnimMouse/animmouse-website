---
title: 'My ASN Journey: Bring home the IPv6 via SOCKS5'
description: How to use your IPv6 address at home using SOCKS5
date: 2024-04-28T00:09:00+08:00
tags:
  - ASN
  - VPS
  - IPv6
  - tutorials
---
Now that we have our own IPv6 address working, it's time to use it as a proxy to your home.

This tutorial assumes you have Debian installed on your VPS.\
Take note that SOCKS5 is unencrypted, you should only run it inside a SSH tunnel or a WireGuard tunnel.

Since Dante can use a specified source IP, it does not require setting a source IP on the routing table.

## Setup Dante SOCKS5 proxy

1. Install Dante.\
`sudo apt install dante-server`

2. Delete Dante's default config file.\
`sudo rm /etc/danted.conf`

3. Create new Dante config file.\
`sudo nano /etc/danted.conf`

Here is an example config for Dante over an SSH tunnel.\
Since we are going to tunnel SOCKS5 over SSH, I have disabled authentication.

```conf
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: <Your IPv6 address assigned to your dummy1>

# socks-rules determine what is proxied through the external interface.
socksmethod: none

# client-rules determine who can connect to the internal interface.
clientmethod: none

# Localhost
client pass {
    from: 127.0.0.0/8 to: 0.0.0.0/0
}

client block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect error
}

socks pass {
    from: 0/0 to: 0/0
}
```

Here is an example config for Dante over an SSH tunnel and Cloudflare WARP's WireGuard tunnel.

```conf
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: <Your IPv6 address assigned to your dummy1>

# socks-rules determine what is proxied through the external interface.
socksmethod: none

# client-rules determine who can connect to the internal interface.
clientmethod: none

# Cloudflare WARP
client pass {
    from: 100.96.0.0/12 to: 0.0.0.0/0
}

# Localhost
client pass {
    from: 127.0.0.0/8 to: 0.0.0.0/0
}

client block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect error
}

socks pass {
    from: 0/0 to: 0/0
}
```

Since my IPv6 only VPS does not have IPv4, I use Cloudflare WARP to get IPv4 connectivity on my VPS.\
Here is an example config for Dante with IPv4 connectivity from Cloudflare WARP.

```conf
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: <Your IPv6 address assigned to your dummy1>
# IPv4 from Cloudflare WARP WireGuard
external: wg0

# socks-rules determine what is proxied through the external interface.
socksmethod: none

# client-rules determine who can connect to the internal interface.
clientmethod: none

# Cloudflare WARP
client pass {
    from: 100.96.0.0/12 to: 0.0.0.0/0
}

# Localhost
client pass {
    from: 127.0.0.0/8 to: 0.0.0.0/0
}

client block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect error
}

socks pass {
    from: 0/0 to: 0/0
}
```

Combining all together, here is my example config using my own IPv6 prefix.

```conf
logoutput: syslog
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: 2a0f:85c1:3b2::
# IPv4 from Cloudflare WARP WireGuard
external: wg0

# socks-rules determine what is proxied through the external interface.
socksmethod: none

# client-rules determine who can connect to the internal interface.
clientmethod: none

# Cloudflare WARP
client pass {
    from: 100.96.0.0/12 to: 0.0.0.0/0
}

# Localhost
client pass {
    from: 127.0.0.0/8 to: 0.0.0.0/0
}

client block {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect error
}

socks pass {
    from: 0/0 to: 0/0
}
```

4. Restart Dante proxy.\
`sudo systemctl restart danted.service`

5. Check status of Dante proxy.\
`sudo systemctl status danted.service`

## Connect to your SOCKS5 proxy

Now that the SOCKS5 proxy is working, we can verify if it is working.

### Using SSH tunnel

1. Connect to your VPS server using SSH with SSH port forwarding.

2. Use curl to check if the proxy is working and if is returning right IPv6 address.\
`curl -x socks5://localhost:1080 api.myip.com`

If it returns your IPv6 prefix, it is now working and you can use it on a browser like Firefox.

### Using Cloudflare WARP WireGuard

1. Use curl to check if the proxy is working and if is returning right IPv6 address.\
`curl -x socks5://<IPv4 address of the server on Cloudflare WARP>:1080 -6 api.myip.com`

Example: `curl -x socks5://100.96.0.6:1080 api.myip.com`