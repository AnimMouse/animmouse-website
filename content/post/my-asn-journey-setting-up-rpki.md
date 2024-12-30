---
title: 'My ASN Journey: Setting up RPKI'
description: How to set up RPKI ROA on your prefix and enable RPKI route filtering
date: 2024-05-28T00:29:00+08:00
lastmod: 2024-12-31T02:15:00+08:00
tags:
  - ASN
  - BGP
  - IPv6
  - tutorials
---
Resource Public Key Infrastructure (RPKI)'s Route Origin Authorizations (ROAs) is like a route6 object found in the Internet Routing Registry (IRR), but with added security since only those who have the private key for the prefix can make and sign ROAs.

Anyone can make a route6 object for a given ASN and prefix, but making ROAs requires someone who has the private key to make it.

## Set up RPKI ROA on your prefix

RPKI ROA for your prefix can either be made using your LIR's panel or by opening a support ticket. In my case and for this tutorial, I requested Lagrange Cloud, my LIR, to make a ROA for my prefix via their panel.

## Set up RPKI route filtering

Test your configuration first by pinging `invalid.rpki.isbgpsafeyet.com` using the command `ping -6 invalid.rpki.isbgpsafeyet.com`. If you can ping, it means that RPKI filtering is not yet enabled.

Currently, our configuration accepts a default route from the upstreams. To make RPKI filtering work, allow BIRD to create an unreachable default route so that any routes that are rejected will be blackholed.

Comment out or remove this line in order for BIRD to create an unreachable default route.

```yaml
#accept-default: true # Don't accept default route from upstreams
#default-route: false # Allows BIRD to make a default route that is blackholed
```

### Plain RPKI to Router (RTR)

1. Choose an RTR server to use. You can use my IPv6 ROAs only RTR server at `rtr-v6.215150.xyz:3323` to save some RAM.
```yaml
rtr-server: rtr-v6.215150.xyz:3323
```

2. Generate BIRD2 config from Pathvector.\
`sudo pathvector generate`

3. Check the BGP session. If you see "Established" on rpki1, then the RPKI is working.\
`sudo birdc show protocol`

Example output:
```
BIRD 2.15.1 ready.
Name       Proto      Table      State  Since         Info
rpki1      RPKI       ---        up     2024-05-28 00:00:00  Established
```

4. Reload all BIRD routes to start rejecting RPKI invalids.\
`sudo birdc reload in all`

Now try to ping `invalid.rpki.isbgpsafeyet.com`. If it says no route to host, it means that you are now filtering RPKI invalids.

### RTR over HTTPS (RTRTR)

Since plain RTR is insecure, it is recommend to use RTRTR to get RTR over HTTPS.

1. Install RTRTR.
```sh
sudo wget -O /usr/share/keyrings/nlnetlabs-archive-keyring.asc https://packages.nlnetlabs.nl/aptkey.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.asc] https://packages.nlnetlabs.nl/linux/debian $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/nlnetlabs.list
sudo apt update
sudo apt install rtrtr
```

2. Delete RTRTR's default config file.\
`sudo rm /etc/rtrtr.conf`

3. Create new RTRTR config file.\
`sudo nano /etc/rtrtr.conf`

Here is an example config that uses my IPv6 ROAs only RTRTR JSON server at\
`https://rpki.215150.xyz/rpki-v6.json`.

```toml
log_level = "warn"
log_target = "stderr"
http-listen = []

[units.as215150-v6-json]
type = "json"
uri = "https://rpki.215150.xyz/rpki-v6.json"
refresh = 3600

[targets.local-3323]
type = "rtr"
listen = [ "[::1]:3323" ]
unit = "as215150-v6-json"
```

4. Enable and start RTRTR.\
`sudo systemctl enable --now rtrtr`

5. Point RTR server to localhost.
```yaml
rtr-server: ip6-localhost:3323
```

6. Generate BIRD2 config from Pathvector.\
`sudo pathvector generate`

7. Check the BGP session. If you see "Established" on rpki1, then the RPKI is working.\
`sudo birdc show protocol`

## List of RTRTR servers (RTR over HTTPS)
1. AS215150 (IPv6 ROAs only): `https://rpki.215150.xyz/rpki-v6.json`
2. AS54148 (IPv6 ROAs only): `https://rpki.as54148.net/rpki-v6.json`
3. AS200351 (IPv6 ROAs only, only accessible on IPv4): `https://rpki.as200351.net/rpki-v6.json`
4. AS13335 (IPv6 and IPv4 ROAs): `https://rpki.cloudflare.com/rpki.json`

## List of RTR servers (plain RTR)
1. AS215150 (IPv6 ROAs only, only accessible on IPv6): `rtr-v6.215150.xyz:3323`
2. AS47272 UK (IPv6 and IPv4 ROAs): `rtr.47272.net:3323`
3. AS47272 US (IPv6 and IPv4 ROAs): `rtr-us.47272.net:3323`
4. AS52210 (IPv6 and IPv4 ROAs): `rtr.accuris.ca:3323`