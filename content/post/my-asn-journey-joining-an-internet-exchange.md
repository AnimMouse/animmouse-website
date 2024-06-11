---
title: 'My ASN Journey: Joining an Internet Exchange'
description: How to join an IXP using your ASN and peer with other ASNs
date: 2024-05-19T21:14:00+08:00
lastmod: 2024-06-11T21:06:00+08:00
tags:
  - ASN
  - BGP
  - VPS
  - IPv6
  - tutorials
---
Now that we have successfully announced our ASN, it is time to do some multihoming and connect to an Internet Exchange.

An Internet Exchange Point (IXP) is basically a big Ethernet switch that allows people with an ASN just like you to peer with each other via BGP.

Benefits of connecting to IXPs:
1. You can easily have more upstream; by having more upstream, your ASN will stop running afoul of RIPE's requirement to be multihomed in order to have an ASN.
2. You are not bound to terms on your upstream. For example, if your upstream limits your data usage and you have a server connected to the same IXP you wish to transfer data to/from, then all bandwidth usage inside the IXP is not counted on your upstream.

## Finding an IXP to join

The IXP you can join is limited to what your provider can provide. Since my BGP VPS is in iFog, for this tutorial, I will join [FogIXP](https://fogixp.org).

## Joining an IXP

Before joining an IXP, run `ip link show` first. This will list all of your current interfaces, so you can easily know later what interface is added later on when you have joined an IXP.

Joining an IXP can either be done using your VPS provider's panel, by opening a support ticket, or on IXP's website.

After the IXP granted you membership, they will send you your IXP Manager credentials via email or via ticket.\
Login to your IXP's IXP Manager and you will get your own peering IPv6 address and the route server's IPv6 address.

Run `ip link show` again, and then you will see a new interface has been added to your VPS. In my case and for this tutorial, it is `ens19`.

## Set up IXP on your VPS

1. Create an interface configuration for that recently added interface.\
`sudo nano /etc/network/interfaces.d/<Interface name>`

For example: `sudo nano /etc/network/interfaces.d/ens19`

2. Paste this configuration and edit.
```
auto <Interface name>
iface <Interface name> inet6 static
    address <Your IPv6 address that the IXP assigned to you>/64
    accept_ra 0 # Disable SLAAC and RA on that interface
```

Here is an example config with my interface and my IPv6 address from FogIXP.

```
auto ens19
iface ens19 inet6 static
    address 2001:7f8:ca:1::21:5150:1/64
    accept_ra 0
```

3. Reload the interface so we get rid of the autoconfigured IPv6 address and apply our assigned IPv6 address.
```sh
sudo ifdown <Interface name>
sudo ifup <Interface name>
```

4. Run `ip -6 addr` to make sure that your assigned IPv6 address is assigned to the interface.

## Set up BGP session

### Moving to full table config

If you followed my [tutorial](../my-asn-journey-configuring-bgp-on-vps/#set-up-bgp-on-your-vps) on how we set up our first BGP session, take note that we used a default route config by not exporting the routes to the kernel. Now that we are going to have multiple peers, it is time to do a full table config.\
Take note that this will consume more RAM, so it is much better if you set up a swap space first just in case.

1. Comment out or remove this lines in order for BIRD to export the routes to the kernel.
```yaml
#kernel:
#  export: true
```

As BIRD will now export the route to the kernel, every route should have a source IP. Remember what we [did last time](../my-asn-journey-configuring-bgp-on-vps/#setting-the-source-ip-via-the-routing-table) by setting the source IP to the default route?\
This will be the equivalent to that but instead of setting the source IP to the default route, BIRD will set the source IP on every route to be exported into the kernel.

2. Add a source6 by specifying your IPv6 address assigned to your dummy1.
```yaml
source6: "<Your IPv6 address assigned to your dummy1>"
```
Example with my announced IPv6 address:
```yaml
source6: "2a0f:85c1:3b2::"
```

### Set up a BGP session with a route server

A route server is where all of the members connected to the IXP exchange routes with each other, since creating a BGP session for every member to you is basically not so scalable.\
And so that you don't need to email every member of the IXP to exchange routes with you.

1. Add a route server template to your Pathvector config.
```yaml
templates:
  routeserver:
    filter-transit-asns: true
    auto-import-limits: true
    enforce-peer-nexthop: false # Allow routes with next hop not equal to the configured neighbor address, good for route servers
    enforce-first-as: false # Allow routes with first AS in AS path not equal to the configured AS number, good for route servers
    announce: [ "<Your ASN>:0:15" ] # Also announce routes with BGP community attribute entitled "Learned from downstream"
    remove-all-communities: <Your ASN>
    local-pref: 90
    add-on-import: [ "<Your ASN>:0:13" ] # Add a BGP community attribute entitled "Learned from route server" on routes imported here
```
Example with my ASN:
```yaml
templates:
  routeserver:
    filter-transit-asns: true
    auto-import-limits: true
    enforce-peer-nexthop: false
    enforce-first-as: false
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 90
    add-on-import: [ "215150:0:13" ]
```

2. Add the route server to your peer list. You can specify all the route server's IP addresses on neighbors.
```yaml
peers:
  <IXP's name>:
    asn: <Route server's ASN>
    template: routeserver
    neighbors:
      - <Route server's IPv6 address>
```
Example with FogIXP's route servers:
```yaml
peers:
  FogIXP:
    asn: 47498
    template: routeserver
    neighbors:
      - 2001:7f8:ca:1::111
      - 2001:7f8:ca:1::222
```

### Set up a BGP session with peers

If you contacted someone on the IXP and they wanted to peer with you, you can establish a direct BGP session with both of you, bypassing the route servers.

1. Install bgpq4.\
`sudo apt install bgpq4`

2. Add a peer template to your Pathvector config.
```yaml
templates:
  peer:
    filter-irr: true
    filter-transit-asns: true
    auto-import-limits: true
    auto-as-set: true
    announce: [ "<Your ASN>:0:15" ] # Also announce routes with BGP community attribute entitled "Learned from downstream"
    remove-all-communities: <Your ASN>
    local-pref: 100
    add-on-import: [ "<Your ASN>:0:14" ] # Add a BGP community attribute entitled "Learned from peer" on routes imported here
```
Example with my ASN:
```yaml
templates:
  peer:
    filter-irr: true
    filter-transit-asns: true
    auto-import-limits: true
    auto-as-set: true
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 100
    add-on-import: [ "215150:0:14" ]
```

3. Add the peer to your peer list.
```yaml
  <Your peer's name>:
    asn: <Your peer's ASN>
    template: peer
    neighbors:
      - <Your peer's IPv6 address>
```
Example with my peers AS200879 and AS199676 on FogIXP:
```yaml
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

### Establish the BGP sessions

Combining all of those, this will be the resulting Pathvector config:
```yaml
asn: 215150
router-id: 10.215.150.44
accept-default: true
default-route: false
keep-filtered: true
bgpq-args: -S AFRINIC,APNIC,ARIN,LACNIC,RIPE
source6: "2a0f:85c1:3b2::"

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
NAVARRO_AS199676_v6 BGP        ---        up     2024-05-19 00:00:00  Established
OLIDELES_AS200879_v6 BGP        ---        up     2024-05-19 00:00:00  Established
IFOG_AS34927_v6 BGP        ---        up     2024-05-19 00:00:00  Established
FOGIXP_AS47498_v6 BGP        ---        up     2024-05-19 00:00:00  Established
FOGIXP_AS47498_v6_1 BGP        ---        up     2024-05-19 00:00:00  Established
```
3. Check the status of your prefix to see if it is being exported/announced to your peers.\
`sudo birdc show route export <BGP session name> all`\
Example: `sudo birdc show route export FOGIXP_AS47498_v6 all`

Example output:
```
BIRD 2.15.1 ready.
Table master6:
2a0f:85c1:3b2::/48   unicast [direct1 2024-05-19 00:00:00] * (240)
        dev dummy1
        Type: device univ
        BGP.as_path:
```
4. If you are also a member of FogIXP, you can check my prefix if it goes to the route server than your upstream. The highest route is the preferred route.\
`sudo birdc show route 2a0f:85c1:3b2::/48`