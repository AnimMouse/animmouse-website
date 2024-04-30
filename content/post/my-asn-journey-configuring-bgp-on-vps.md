---
title: 'My ASN Journey: Configuring BGP on VPS'
description: How to configure BGP using BIRD and announce your IPv6 prefix on VPS
date: 2024-04-24T22:24:00+08:00
lastmod: 2024-05-01T00:37:00+08:00
tags:
  - ASN
  - BGP
  - VPS
  - IPv6
  - tutorials
---
Your first BGP session, a comprehensive beginners guide to BGP.

## Finding a VPS that can provide BGP session

You can find VPS providers here that provides BGP session.
* [BGP Services](https://bgp.services)
* [BGP Cheap](https://bgp.cheap)
* [BGP Directory](https://bgp.directory)
* [Networking: IPv6 Discord server](https://discord.gg/ipv6)

For this tutorial, I use a BGP IPv6 only VPS from [iFog GmbH](https://my.ifog.ch/order/main/packages/ipv6-only-vps/?a=MTUyNQ==) since it is very cheap.\
Since this is an IPv6 only VPS and I don't have native IPv6, I use Cloudflare WARP to SSH to my IPv6 only VPS.

## Tell your VPS provider to set up BGP on their side

This can either be done using your VPS provider's panel, or by opening a support ticket.\
When the VPS provider has set up their BGP on their side, they will provide you their ASN and their peer IPv6 address.

They will also verify if you own your ASN by telling you to [add import and export statement on your ASN routing policy](../my-asn-journey-setting-up-your-own-asn/#create-a-routing-policy-statement-on-your-asn).
```text
import: from <VPS provider's ASN> accept ANY
export: to <VPS provider's ASN> announce <Your ASN>
```

## Prerequisites

1. A [BGP VPS](#finding-a-vps-that-can-provide-bgp-session) preferably with Debian installed.
2. Your own ASN. `<Your ASN>`
3. VPS provider's ASN. `<VPS provider's ASN>`
4. Your VPS's IPv6 address. `<Your VPS's IPv6 address>`
5. VPS provider's peering IPv6 address. `<VPS provider's IPv6 address>`
6. Your IPv6 prefix. `<Your IPv6 prefix>`
7. Your BGP router ID. `<Your router ID>`
8. [A route6 object at the RIPE IRR database.](../my-asn-journey-setting-up-your-own-asn/#create-a-route6-object-in-the-ripe-irr-database)
9. [A routing policy statement on your ASN.](../my-asn-journey-setting-up-your-own-asn/#create-a-routing-policy-statement-on-your-asn)

## Creating your own BGP router ID

The BGP router ID is a 4-byte unique identifier of a BGP router in an AS. It is formatted like an IPv4 address. (`0.0.0.0` to `255.255.255.255`)\
If your VPS already has an IPv4 address, you can use your VPS's IPv4 address as a router ID. If your VPS does not have an IPv4 address, you can use my own conventions:

1. Use 0, 10, 127, or 240-255 as the 1st octet, since those are reserved IPv4 address, and use your ASN number for the 2nd and 3rd octet, and choose your own number for the 4th octet.\
Example: My ASN is AS215150, the 2nd and 3rd octet is `215.150`, then I choose a number for the 4th octet like this `10.215.150.0` or generate a random number like this `10.215.150.247`.\
If your ASN's 1st or 2nd octet is higher than 256 like AS200879, you can limit the big number to 256 like this `10.200.256.0` or just generate a random number for the big number like this `10.200.247.0`.

2. Generate a random number. Use 0, 10, 127, or 240-255 as the 1st octet, and generate a random number for the 2nd, 3rd and 4th octet like this `10.215.150.247`.

## Set up BGP on your VPS

1. Install BIRD2. This will become our BGP daemon so that we can export our prefixes to the internet.\
`sudo apt install bird2`
2. Install Pathvector. This is an abstraction to BIRD2's config, which makes it easier to configure BIRD2.
```sh
sudo -i
curl https://repo.pathvector.io/pgp.asc > /usr/share/keyrings/pathvector.asc
echo "deb [signed-by=/usr/share/keyrings/pathvector.asc] https://repo.pathvector.io/apt/ stable main" > /etc/apt/sources.list.d/pathvector.list
apt install pathvector
```
3. Create the Pathvector config.\
`sudo nano /etc/pathvector.yml`

For our first BGP session, here is an example config for a single upstream provider.\
This is also a default route config by not importing the routes to the kernel. Default route config is easier to understand for beginners.\
Don't worry we will move to full table config when we have 2 or more peers.

```yaml
asn: <Your ASN>
router-id: <Your router ID>
accept-default: true
default-route: false
keep-filtered: true
bgpq-args: -S AFRINIC,APNIC,ARIN,LACNIC,RIPE

prefixes:
  - <Your IPv6 prefix>

kernel:
  export: false # Don't import the routes from BGP to our kernel
  statics:
    "<Your IPv6 prefix>": "<Your VPS's IPv6 address>" # Tells your peers via BGP that <Your IPv6 prefix> is accessible via <Your VPS's IPv6 address>

templates:
  upstream:
    allow-local-as: true
    announce: [ "<Your ASN>:0:15" ]
    remove-all-communities: <Your ASN>
    local-pref: 80
    add-on-import: [ "<Your ASN>:0:12" ]

peers:
  <VPS provider's name>:
    asn: <VPS provider's ASN>
    multihop: true
    template: upstream
    enforce-peer-nexthop: false
    enforce-first-as: false
    neighbors:
      - <VPS provider's IPv6 address>
```

Here is an example config with my ASN using iFog as the upstream.

```yaml
asn: 215150
router-id: 10.215.150.44
accept-default: true
default-route: false
keep-filtered: true
bgpq-args: -S AFRINIC,APNIC,ARIN,LACNIC,RIPE

prefixes:
  - 2a0f:85c1:3b2::/48

kernel:
  export: false # Don't import the routes from BGP to our kernel
  statics:
    "2a0f:85c1:3b2::/48": "2a0c:9a40:2510:1001::10fa" # Tells your peers via BGP that 2a0f:85c1:3b2::/48 is accessible via 2a0c:9a40:2510:1001::10fa

templates:
  upstream:
    allow-local-as: true
    announce: [ "215150:0:15" ]
    remove-all-communities: 215150
    local-pref: 80
    add-on-import: [ "215150:0:12" ]

peers:
  iFog:
    asn: 34927
    multihop: true
    template: upstream
    enforce-peer-nexthop: false
    enforce-first-as: false
    neighbors:
      - 2a0c:9a40:2510:1001::1
```

4. Generate BIRD2 config from Pathvector.\
`sudo pathvector generate`
5. Check BGP session. If you see "Established", then BGP session is working.\
`sudo birdc show protocol`
6. Check BGP session on a specific session. Replace `<BGP session name>` with name from step 5.\
`sudo birdc show protocol all <BGP session name>`\
Example: `sudo birdc show protocol all IFOG_AS34927_v6`
7. Check the status of your prefix if it is being exported/announced. If your prefix is there, it means it is currently exported/announced to the internet. It is normal for it to be unreachable as we haven't assigned the IPv6 address to an interface yet.\
`sudo birdc show route export <BGP session name> all`\
Example: `sudo birdc show route export IFOG_AS34927_v6 all`

## Set up your IPv6 prefix on your VPS

Now that we have successfully told the internet that your prefix can be accessible to your VPS, the next step is to assign an IPv6 address to your VPS from your IPv6 prefix.\
We can't just set the source IP of an IP packet without the source IP being assigned to an interface.

### Set up a dummy interface

We need to create a dummy interface in order for us to have an interface where we assign the IP address. We can't just assign our IP address to `eth0` since your IPv6 prefix technically does not exist within the `eth0` interface. A dummy interface works like a loopback interface.

1. Create a dummy interface configuration.\
`sudo nano /etc/network/interfaces.d/dummy1`

2. Paste this configuration and edit.
```
auto dummy1
iface dummy1 inet6 static
    address <IPv6 address to assign from your IPv6 prefix>
    pre-up ip link add $IFACE type dummy
    post-down ip link del $IFACE
```

Here is an example config that assigns the first IPv6 address from my IPv6 prefix.

```
auto dummy1
iface dummy1 inet6 static
    address 2a0f:85c1:3b2::/48
    pre-up ip link add $IFACE type dummy
    post-down ip link del $IFACE
```

3. Now let's bring the dummy interface up.\
`sudo ifup dummy1`

4. Check the status of your prefix to see if it is now reachable. If it says unicast, it means that your IPv6 address is now reachable to the internet.\
`sudo birdc show route export <BGP session name> all`

5. Since your IPv6 address is now reachable, you can now ping your IPv6 address at home or even connect to your VPS via SSH using that announced prefix after the prefix has propagated over the internet.

#### Manual configuration

This does not persist after a reboot.

1. Create a dummy interface.\
`sudo ip link add dummy1 type dummy`

2. Assign an IPv6 address to the dummy1 interface.\
`sudo ip -6 addr add <IPv6 address to assign from your IPv6 prefix> dev dummy1`

Example: `sudo ip -6 addr add 2a0f:85c1:3b2::/48 dev dummy1`

### BGP route propagation

Just like DNS (It's Always DNS!), it takes time for the route that tells your IPv6 prefix where it is, to be propagated across the routers. It can take up to 72 hours for the whole internet to accept your prefixes.\
During the period where the route has not yet propagated, you can't ping or use your IPv6 address as a source IP in the meantime.

You can use [NLNOG Looking Glass](https://lg.ring.nlnog.net) to check the status of your route propagation by entering your IPv6 prefix there.

If after 72 hours and still your prefix is still not reachable, you can use [NLNOG IRR Explorer](https://irrexplorer.nlnog.net) to check if you have a valid route6 object, and if you don't have any RPKI invalids.

## Use your IPv6 address as a source IP

Now that we can now ping our announced IPv6 prefix to the internet, we can now eyeball contents on the internet using your IPv6 prefix.

### Programs that support setting source IP on itself

Some programs like ping and curl can bind to specific address on itself.

1. Ping a server using your announced IPv6 address.\
`ping -I <Your IPv6 address assigned to your dummy1> <IPv6 address to ping>`\
Example: `ping -I 2a0f:85c1:3b2:: 2001:4860:4860::8888`

2. Get the IPv6 address of your server using curl.\
`curl --interface <Your IPv6 address assigned to your dummy1> api.myip.com`\
Example: `curl --interface 2a0f:85c1:3b2:: api.myip.com`

### Setting the source IP via the routing table

What if you don't want to specify the IP address and you want `curl api.myip.com` to return the announced IPv6 address every time?

1. Check the routing table.\
`ip -6 route`

At the very end of the routing table, we can see the default route, just like this:
```
default via <Gateway IPv6 address> dev eth0 metric 1024 onlink pref medium
```
Example with my gateway IPv6 address:
```
default via 2a0c:9a40:2510:1001::1 dev eth0 metric 1024 onlink pref medium
```
We can add a new default route with a lower metric than that default route but with a source IP set to your announced IPv6 address.

2. Create a new default route with a lower metric and a source IP address.\
`sudo ip -6 route add default via <Gateway IPv6 address> dev eth0 src <Your IPv6 address assigned to your dummy1> metric 512`\
Example with my gateway and announced IPv6 address:\
`sudo ip -6 route add default via 2a0c:9a40:2510:1001::1 dev eth0 src 2a0f:85c1:3b2:: metric 512`

3. Check the routing table again. Take note that there are 2 default routes, but 1 default route with a source IP is higher.\
`ip -6 route`
```
default via <Gateway IPv6 address> dev eth0 src <Your IPv6 address assigned to your dummy1> metric 512 pref medium
default via <Gateway IPv6 address> dev eth0 metric 1024 onlink pref medium
```

4. Check using curl without a specified address if the source IP is correct.\
`curl api.myip.com`

## Using a different IPv6 address from your prefix.

One of the benefits of IPv6 is you have huge number of IP address to use from.\
What if I wanted to use `2a0f:85c1:3b2::1:5ee:900d:c0de` (I see good code) as my IPv6 address?

1. Assign your chosen IPv6 address to the dummy1 interface.

Automatic: Add your chosen IPv6 address to `/etc/network/interfaces.d/dummy1`.
```
auto dummy1
iface dummy1 inet6 static
    address 2a0f:85c1:3b2::/48
    address 2a0f:85c1:3b2::1:5ee:900d:c0de/48
    pre-up ip link add $IFACE type dummy
    post-down ip link del $IFACE
```

Manual: `sudo ip -6 addr add 2a0f:85c1:3b2::1:5ee:900d:c0de/48 dev dummy1`

2. Use curl to check if you are getting the right IPv6 address.\
`curl --interface 2a0f:85c1:3b2::1:5ee:900d:c0de api.myip.com`

Now that we have your own IPv6 prefix working on your VPS, it is time to bring home the IPv6 using [SOCKS5](../my-asn-journey-bring-home-the-ipv6-via-socks5/) or [WireGuard](../my-asn-journey-bring-home-the-ipv6-via-wireguard/).

## Shell cheat sheets

### BIRD Internet Routing Daemon systemd service
```sh
sudo systemctl start bird.service
sudo systemctl stop bird.service
sudo systemctl restart bird.service
sudo systemctl status bird.service
```

### Dummy interface
```sh
sudo ifup dummy1
sudo ifdown dummy1
```

### IPv6 address
```sh
sudo ip -6 addr add <Your chosen IPv6 address> dev dummy1
sudo ip -6 addr del <Your chosen IPv6 address> dev dummy1
```

### Routing table
```sh
sudo ip -6 route add default via <Gateway IPv6 address> dev eth0 src <Your IPv6 address assigned to your dummy1> metric 512
sudo ip -6 route del default via <Gateway IPv6 address> dev eth0 src <Your IPv6 address assigned to your dummy1> metric 512
```