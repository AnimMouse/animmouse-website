---
title: My ASN Journey
description: A comprehensive beginners guide about getting your own ASN and own IP address
date: 2024-04-24T20:05:00+08:00
lastmod: 2024-04-28T00:47:00+08:00
tags:
  - ASN
  - IPv6
  - tutorials
---
Hello, and welcome to my ASN journey, where we explore BGP, and getting our own IP address.

People are buying domain names, which is part of what we called "internet resources."\
If an ordinary people like me can buy domain names, then what about owning an IP address?\
Why can't ordinary people buy an IP address just like domain names?\
Most of the IP address that exist today are owned by the big business and big government.

There are still no concrete tutorials on how to set up BGP from the ground up, so I created my own.

## List of my ASN/BGP tutorials

1. [My ASN Journey: Acquiring your own ASN](../my-asn-journey-acquiring-your-own-asn/)
2. [My ASN Journey: Setting up your own ASN](../my-asn-journey-setting-up-your-own-asn/)
3. [My ASN Journey: Configuring BGP on VPS](../my-asn-journey-configuring-bgp-on-vps/)
4. [My ASN Journey: Bring home the IPv6 via SOCKS5](../my-asn-journey-bring-home-the-ipv6-via-socks5/)
5. My ASN Journey: Bring home the IPv6 via WireGuard (TBD)
6. My ASN Journey: Setting up IP geolocation (TBD)
7. My ASN Journey: Acquiring more IPv6 prefixes (TBD)
8. My ASN Journey: Joining an Internet Exchange (IXP) (TBD)
9. My ASN Journey: Setting up RPKI (TBD)
10. My ASN Journey: Setting up reverse DNS (rDNS) (TBD)

## Rationale

Getting your own IP address has several advantages.

1. Your ISP does not have IPv6, and you want to have IPv6.\
By getting your own ASN and IPv6, you get IPv6 connectivity.
2. Your ISP uses CGNAT, which shares a single IPv4 address across their customers.\
What if someone is abusive? Then that IPv4 address gets banned, and you are also banned.\
Since you are the only one who uses that IPv6 prefix, then your IPv6 prefix is tagged clean.
3. This is basically a VPN, but your IP address is not tagged as a proxy, allowing you to edit on Wikipedia or watch Netflix for example.
4. No more CAPTCHAs since you are the only one using your own IPv6 address.

## Limitations

Why you shouldn't get your own ASN and IP address.

1. Self-doxxing. Unlike domain names, ASN registration has no "domain privacy," and your personal information needs to be published to the internet.\
Unless you have registered a company, RIPE NCC requires verifying your ID.\
Every website you visit using your own IP address has a name tag to you.
2. You can mess up the DFZ. Messing up the default-free zone because of BGP misconfiguration will make network engineers get mad at you.
3. You contribute to the growth of the Internet routing table. Remember 512K day? Brace yourself, 768K day is coming.

## Costs and expenses

* ASN: £15 one-off fee from [Lagrange Cloud](https://lagrange.cloud/products/lir).
* BGP IPv6 only VPS: 5 CHF per 3 months from [iFog GmbH](https://my.ifog.ch/order/main/packages/ipv6-only-vps/?a=MTUyNQ==).

## FAQs

1. Do I need to have an ASN to get and announce my own IP address?\
No, you can ask your provider to announce the IPs for you via a private ASN, but I have not seen a provider that is cheap enough to do BYOIP without an ASN. Getting your own ASN is the best option.

2. Is it possible to get your own IPv4 address?\
Yes, but make sure you have deep pockets ready, this is why this tutorial will focus more about IPv6.

3. Difference between IP transit and peering?
   * IP transit: You will get all prefixes on the internet or a default route.
   * Peering: You will get only prefixes for that particular AS and their downstream AS.
      * Semi-transit: When a network became so large like Hurricane Electric that peering with them allows you to access almost half of the world's internet.

4. Should I play on dn42 first before going inside the BGP rabbit hole?\
You can, but not a requirement. But some knowledge about networking and setting up a VPS is definitely needed.

5. If I brought an IPv6 only VPS, how can I access it if my ISP does not have IPv6?\
Use Cloudflare WARP. Or better yet setup Cloudflare WARP-to-WARP on your router.

## Other useful resources

* [Networking: IPv6 Discord server](https://discord.gg/ipv6)
* [Why and how I got my own ASN!](https://chown.me/blog/getting-my-own-asn)
* [What I wish I knew when I got my ASN](https://quantum5.ca/2023/10/10/what-i-wish-i-knew-when-i-got-my-asn)
* [The Beginner’s Guide: ASN Setup](https://www.lir.services/blog/asn-setup/)
* [BGP.training](https://bgp.training)