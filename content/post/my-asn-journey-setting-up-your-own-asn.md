---
title: 'My ASN Journey: Setting up your own ASN'
description: How to set up your personal ASN
date: 2024-04-24T20:35:00+08:00
lastmod: 2025-01-02T01:02:00+08:00
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

### Best practice information

Things you should put in PeeringDB.

1. IRR as-set/route-set: [Your AS-SET for IXPs](#as-set-for-ixps)
2. Network Types: Educational/Research
3. IPv4 Prefixes: 1 (Must not be set to 0 so that Pathvector won't warn.)
4. IPv6 Prefixes: 50
5. Traffic Levels: 100-1000Mbps
6. Traffic Ratios: Mostly Inbound
7. Geographic Scope: Global
8. Protocols Supported: IPv6
9. Allow IXP Update: Checked
10. General Policy: Open

## A domain name for your ASN

If you already have a domain name, you can create a subdomain on it and host a simple website about your ASN.\
This domain name is also where we will host our geofeed, forward-confirmed reverse DNS (FCrDNS), and Network Operations Center (NOC) email later on.

If you want to, you can register a 1.111B class domain on the .xyz TLD with your AS number, and it will only cost you 99¢ per year, just like my ASN on [as.215150.xyz](https://as.215150.xyz).

## Create a BGP.Tools account

[BGP.Tools](https://bgp.tools) is where we do BGP debugging when things go wrong.

1. Create a BGP.Tools by inputting your ASN.
2. BGP.Tools will send you a code to your email that is listed on your ASN's WHOIS.
3. Input that code into BGP.Tools to finish account creation.
4. Set up contact, so that BGP.Tools can update you if something happens to your ASN, like a new route6 object, new upstream, etc.

## Create a route6 object in the RIPE IRR database

Internet Routing Registry (IRR) is a database used to record a connection between an IPv6 address and the originating AS number.\
A route6 object say that your ASN is authorized to announce your IPv6 prefix.

1. Go to [RIPE database's Create an Object](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Under Object type, select route6, and click create.
3. On route6, input your IPv6 prefix.
4. On origin, input your AS number.

Here is an example of my route6 IRR object authorizing my ASN AS215150 to announce my IPv6 prefix `2a0a:6044:accd::/48`:
```text
route6: 2a0a:6044:accd::/48
origin: AS215150
```

## Create a routing policy statement on your ASN

The import and export statements describe your ASN routing policy. Those statements say that your upstream ASN is authorized to announce your ASN.\
Routing policy statements are written in Routing Policy Specification Language (RPSL).
Some providers like iFog GmbH uses import and export statements to verify that you own your ASN.

Some LIRs like Lagrange Cloud automatically add an import and export statement using the 2 peering details when you first acquire your ASN. If this happens, you already have the required import and export statements.

1. Go to the [RIPE database's My Resources (ASN)](https://apps.db.ripe.net/db-web-ui/myresources/overview?type=aut-num).
2. Click on your ASN.
3. Click Update object.
4. At the sponsoring-org attribute, click the + (plus) icon.
5. Select import, and click add.
6. On import, input your upstream ASN following this convention:\
`from <Upstream ASN> accept ANY`
7. At the import attribute, click the + (plus) icon.
8. Select export, and click add.
9. On export, input your upstream ASN and your ASN following this convention:\
`to <Upstream ASN> announce <Your ASN>`

Here is an example of my routing policy statement authorizing iFog GmbH AS34927 to announce my ASN AS215150:
```text
import: from AS34927 accept ANY
export: to AS34927 announce AS215150
```

## Create an AS-SET

An AS-SET is basically an array variable that holds multiple ASNs which you can use in RPSL.\
IXPs requires you to have an AS-SET which they will use for their own routing policy statements.

### AS-SET for IXPs

1. Go to the [RIPE database's Create an Object](https://apps.db.ripe.net/db-web-ui/webupdates/select).
2. Under Object type, select as-set, and click create.
3. On as-set, input the name of your AS-SET following this convention (Hierarchical AS-SET):\
`<AS number>:AS-<Your ASN name>`
4. On tech-c and admin-c, input the same tech-c and admin-c as listed on your ASN's WHOIS.
5. At the as-set attribute, click the + (plus) icon.
6. Select members, and click add.
7. On members, input your own ASN.

Here is an example of my AS-SET for IXPs:
```text
as-set: AS215150:AS-ANIMMOUSE
members: AS215150
```

### AS-SET example usage

#### Upstream

For example, if you have 2 upstreams AS34927 and AS6939, instead of doing this:
```text
import: from AS34927 accept ANY
export: to AS34927 announce AS215150
import: from AS6939 accept ANY
export: to AS6939 announce AS215150
```

You can do this:
```text
import: from AS215150:AS-UPSTREAMS accept ANY
export: to AS215150:AS-UPSTREAMS announce AS215150
```
```text
as-set: AS215150:AS-UPSTREAMS
members: AS34927
members: AS6939
```

If you already have an AS-SET for IXPs, you can also do this:
```text
import: from AS215150:AS-UPSTREAMS accept ANY
export: to AS215150:AS-UPSTREAMS announce AS215150:AS-ANIMMOUSE
```
```text
as-set: AS215150:AS-ANIMMOUSE
members: AS215150
```
```text
as-set: AS215150:AS-UPSTREAMS
members: AS34927
members: AS6939
```

Now that we have set up your ASN, it is time to [set up BGP on a VPS](../my-asn-journey-configuring-bgp-on-vps/).