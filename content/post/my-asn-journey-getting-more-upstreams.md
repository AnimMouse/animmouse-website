---
title: 'My ASN Journey: Getting more upstreams'
description: How to get more upstreams/transit on your ASN
date: 2024-06-03T23:12:00+08:00
lastmod: 2024-06-09T02:26:00+08:00
tags:
  - ASN
  - BGP
  - IPv6
  - tutorials
---
One of the RIPE's requirements in order for you to have an ASN is that you must be multihomed.

Benefits of having multiple upstreams:
1. Your ASN will stop running afoul of RIPE's requirement to be multihomed in order to have an ASN.
2. If your main upstream goes down, you still have a backup working, like a multiple WAN.
3. You can potentially get better routing if your other upstreams have a lower number of hops.

## List of free transit providers

Non-exhaustive list of free transit providers.

1. [Freetransit Project](https://freetransit.ch)
2. [HYEHOST LTD](https://hyehost.store/store/transit)

## Requesting a transit

### Freetransit Project

Add their ASN to your [import and export statement on your ASN routing policy](../my-asn-journey-setting-up-your-own-asn/#create-a-routing-policy-statement-on-your-asn).

I requested transit on their site by filling up their forms, specifying my ASN, my IPv6 address from FogIXP as my endpoint, and my contact email.

They have [2 endpoints in FogIXP](https://manager.fogixp.org/customer/detail/9), which are Frankfurt at `2001:7f8:ca:1::22`, and Amsterdam at `2001:7f8:ca:1::21`, ping both of them in your VPS and take note the lower latency. My chosen endpoint is Frankfurt.

They will email you about the list of prefixes you will announce. Reply to their email with the list of your prefixes.\
They will also clarify what endpoint you choose, specify "via FogIXP" and their FogIXP location at "Frankfurt" and your FogIXP endpoint.

After that, they will say that their end is deployed, you can now connect by adding this to your Pathvector config:

```yaml
peers:
  Freetransit:
    asn: 41051
    template: upstream
    neighbors:
      - 2001:7f8:ca:1::22
```

### HYEHOST LTD

Add their ASN to your import and export statement on your ASN routing policy, just like before.

They have [2 endpoints in FogIXP](https://manager.fogixp.org/customer/detail/322), which are Frankfurt at `2001:7f8:ca:1::4:7272:1`, and Amsterdam at `2001:7f8:ca:1::4:7272:2`, ping both of them in your VPS and take note the lower latency. My chosen endpoint is Frankfurt.

HYEHOST LTD is more automated, you just create an order on their store, ordering "Free BGP Transit Frankfurt," specifying my ASN, my IPv6 address from FogIXP as my endpoint, and my contact information.

After that, you will receive an email saying that the transit session is deployed on their side, you can now connect by adding this to your Pathvector config:

```yaml
peers:
  HYEHOST:
    asn: 47272
    template: upstream
    neighbors:
      - 2001:7f8:ca:1:0:4:7272:1
```

## Accounting for latency

If your ping on those upstreams is higher than your main upstream, like my latency to those is 11 ms, and my main upstream is just at 0.1 ms, you should deprioritize those upstreams to maintain optimal latency.

If your default local-pref at the upstream template is 80, set the local-pref of those upstreams lower than 80, like 70.

```yaml
peers:
  Freetransit:
    asn: 41051
    template: upstream
    local-pref: 70
    neighbors:
      - 2001:7f8:ca:1::22

  HYEHOST:
    asn: 47272
    template: upstream
    local-pref: 70
    neighbors:
      - 2001:7f8:ca:1:0:4:7272:1
```

## Enable ECMP

Equal-cost multi-path routing (ECMP) allows you to load balance traffic to multiple upstreams. Currently in our setup, only a single upstream will be used that is preferred by BIRD. By enabling ECMP, BIRD will allow the use of multiple upstreams for load balancing.

Add this to your Pathvector config to enable ECMP:
```yaml
merge-paths: true
```

## Establish the BGP sessions

Combining all of those, this will be the resulting Pathvector config:

```yaml
asn: 215150
router-id: 10.215.150.44
accept-default: true
default-route: false
keep-filtered: true
bgpq-args: -S AFRINIC,APNIC,ARIN,LACNIC,RIPE
source6: "2a0f:85c1:3b2::"
merge-paths: true

prefixes:
  - 2a0f:85c1:3b2::/48

templates:
  upstream:
    allow-local-as: true
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 80
    add-on-import: [ "215150:0:12" ]

  routeserver:
    filter-transit-asns: true
    auto-import-limits: true
    enforce-peer-nexthop: false
    enforce-first-as: false
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 90
    add-on-import: [ "215150:0:13" ]

  peer:
    filter-irr: true
    filter-transit-asns: true
    auto-import-limits: true
    auto-as-set: true
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 100
    add-on-import: [ "215150:0:14" ]

peers:
  iFog:
    asn: 34927
    template: upstream
    neighbors:
      - 2a0c:9a40:2510:1001::1

  Freetransit:
    asn: 41051
    template: upstream
    local-pref: 70
    neighbors:
      - 2001:7f8:ca:1::22

  HYEHOST:
    asn: 47272
    template: upstream
    local-pref: 70
    neighbors:
      - 2001:7f8:ca:1:0:4:7272:1

  FogIXP:
    asn: 47498
    template: routeserver
    neighbors:
      - 2001:7f8:ca:1::111
      - 2001:7f8:ca:1::222

  Olideles:
    asn: 200879
    template: peer
    neighbors:
      - 2001:7f8:ca:1::20:0879:1

  Navarro:
    asn: 199676
    template: peer
    neighbors:
      - 2001:7f8:ca:1::19:9676:1
```

1. Generate BIRD2 config from Pathvector.\
`sudo pathvector generate`

2. Check the BGP session. If you see "Established", then the BGP session is working.\
`sudo birdc show protocol`

Example output:
```
BIRD 2.15.1 ready.
Name       Proto      Table      State  Since         Info
NAVARRO_AS199676_v6 BGP        ---        up     2024-06-03 00:00:00  Established
OLIDELES_AS200879_v6 BGP        ---        up     2024-06-03 00:00:00  Established
IFOG_AS34927_v6 BGP        ---        up     2024-06-03 00:00:00  Established
FREETRANSIT_AS41051_v6 BGP        ---        up     2024-06-03 00:00:00  Established
HYEHOST_AS47272_v6 BGP        ---        up     2024-06-03 00:00:00  Established
FOGIXP_AS47498_v6 BGP        ---        up     2024-06-03 00:00:00  Established
FOGIXP_AS47498_v6_1 BGP        ---        up     2024-06-03 00:00:00  Established
```

3. Check the status of your prefix to see if it is being exported/announced to your upstream.\
`sudo birdc show route export <BGP session name> all`\
Example: `sudo birdc show route export FREETRANSIT_AS41051_v6 all`

Example output:
```
BIRD 2.15.1 ready.
Table master6:
2a0f:85c1:3b2::/48   unicast [direct1 2024-06-03 00:00:00] * (240)
        dev dummy1
        Type: device univ
        BGP.as_path:
```