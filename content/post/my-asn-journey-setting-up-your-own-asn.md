---
title: 'My ASN Journey: Setting up your own ASN'
description: How to set up your personal ASN
date: 2024-04-24T20:35:00+08:00
lastmod: 2024-04-27T20:07:00+08:00
tags:
  - ASN
  - IPv6
  - tutorials
---
Now that you have got your very own ASN, it is time to set up your ASN.

## Create a PeeringDB account

A [PeeringDB](https://www.peeringdb.com) is essentially a social media for your ASN, if you are used to looking for someone ASN and wondering where they set their information, is it in PeeringDB.

1. Create a PeeringDB account, preferably using the same email on your ASN's WHOIS for faster verification.
2. Affiliate your ASN.
3. Wait for them to verify your ASN.
4. Enter your information on the PeeringDB page.

## A domain name for your ASN

If you already have a domain name, you can create a subdomain on it and host a simple website about your ASN.\
This domain name is also where we will host our geofeed and forward-confirmed reverse DNS (FCrDNS) later on.

If you want to, you can register a 1.111B class domain on the .xyz TLD with your AS number, and it will only cost you 99¢ per year, just like my ASN on [as.215150.xyz](https://as.215150.xyz).

## Create a BGP.Tools account

[BGP.Tools](https://bgp.tools) is where we do BGP debugging when things go wrong.

1. Create a BGP.Tools by inputting your ASN.
2. BGP.Tools will send you a code to your email that is listed on your ASN's WHOIS.
3. Input that code into BGP.Tools to finish account creation.

## Create a route6 object in the RIPE IRR database

Internet Routing Registry (IRR) is a database used to record a connection between an IPv6 address and the originating AS number.\
A route6 object say that your ASN is authorized to announce your IPv6 prefix.

1. Go to [RIPE database's Create an Object](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Under Object type, select route6, and click create.
3. On route6, input your IPv6 prefix.
4. On origin, input your AS number.

Here is an example of my route6 IRR object authorizing my ASN AS215150 to announce my IPv6 prefix `2a0f:85c1:3b2::/48`:
```text
route6: 2a0f:85c1:3b2::/48
origin: AS215150
```

## Create a routing policy statement on your ASN

The import and export statements describe your ASN routing policy. Those statements say that your upstream ASN is authorized to announce your ASN.\
Some providers like iFog GmbH uses import and export statements to verify that you own your ASN.

Some LIRs like Lagrange Cloud automatically add an import and export statement using the 2 peering details when you first acquire your ASN. If this happens, you already have the required import and export statements.

1. Go to the [RIPE database's My Resources](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Click ASN tab.
3. Click on your ASN.
4. Click Update object.
5. At the sponsoring-org attribute, click the + (plus) icon.
6. Select import, and click add.
7. On import, input the name of your upstream ASN following this convention:\
`from <Upstream ASN> accept ANY`
5. At the import attribute, click the + (plus) icon.
6. Select export, and click add.
7. On export, input the name of your upstream ASN and your ASN following this convention:\
`to <Upstream ASN> announce <Your ASN>`

Here is an example of my routing policy statement authorizing iFog GmbH AS34927 to announce my ASN AS215150:
```text
import: from AS34927 accept ANY
export: to AS34927 announce AS215150
```

## Create an AS-SET (Optional)

Some providers require you to create an AS-SET. If required, here's how to create an AS-SET for your ASN.

1. Go to the [RIPE database's Create an Object](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Under Object type, select as-set, and click create.
3. On as-set, input the name of your AS-SET following this convention:\
`<AS number>:AS-<Your ASN name>`
4. On tech-c and admin-c, input the same tech-c and admin-c as listed on your ASN's WHOIS.

Now that we have set up your ASN, it is time to [set up BGP on a VPS](../my-asn-journey-configuring-bgp-on-vps/).