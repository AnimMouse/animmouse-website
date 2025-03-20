---
title: 'My ASN Journey: Setting up reverse DNS'
description: How to set up rDNS on your prefix
date: 2025-03-10T16:29:00+08:00
draft: true
tags:
  - ASN
  - BGP
  - IPv6
  - tutorials
---
## Set up authoritative DNS

I recommend [Hurricane Electric Free DNS](https://dns.he.net) for this.

1. Click Add a new reverse.
2. On prefix, input your IPv6 prefix.
3. Click Add Prefix.

## Create a domain object in the RIPE IRR database

1. Go to [RIPE database's Create an Object](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Under Object type, select domain, and click create.
3. On prefix, input your IPv6 prefix.
4. On nserver, input your authoritative DNS server. For Hurricane Electric, input `ns4.he.net` and `ns5.he.net`.
5. On admin-c, tech-c, and zone-c, input the same admin-c as listed on your ASN's WHOIS.