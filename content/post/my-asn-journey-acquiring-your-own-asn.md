---
title: 'My ASN Journey: Acquiring your own ASN'
description: How to buy and get your own personal ASN
date: 2024-04-24T20:22:00+08:00
tags:
  - ASN
  - tutorials
---
Buying your own ASN is the start of your ASN journey.

## Regional Internet Registry (RIR)

There are 2 RIRs that are attainable for hobby use; RIPE NCC and ARIN.\
Other RIRs such as APNIC, LACNIC, and AFRINIC are unattainable unless you have big pockets.

### RIPE NCC

RIPE NCC is based in Europe. If you are outside their service area, they require you to have a proof of in-region network presence.\
An example of proof is an invoice for your VPS that is located at Europe.

Registration can be performed under a natural person or a company.

### ARIN

ARIN is based in North America. They require a physical service within ARIN service region. A VPS that is located in North America is not enough.\
You need a dedicated server or a colocation inside ARIN service region.

Registration can only be performed under a business name, so you need to register as a company or a sole proprietorship before ARIN assigns you an ASN.

## Local Internet Registry (LIR)

Since ARIN requires you to have a business registration to get an ASN, RIPE NCC is the only cheap option.

### List of LIRs in the RIPE NCC

Non-exhaustive list of LIRs in the RIPE NCC.

1. [Lagrange Cloud](https://lagrange.cloud/products/lir)
2. [iFog GmbH](https://ifog.ch/en/ip/lir-services)
3. [Bakker IT](https://www.bakker-it.eu/lir-services/)
4. [FREETRANSIT](https://freetransit.ch)
5. [Scaleblade](https://scaleblade.com/products/lir)
6. [Glauca Digital](https://glauca.digital/lir/)
7. [Servperso](https://www.servperso.net/ripe-ncc-lir-services)
8. [HostUS](https://my.hostus.us/store/lir-services)
9. [Divergent Networks](https://divergentnetworks.co.uk/ripe-asn-sponsorship)
10. [TunnelBroker.ch](https://www.tunnelbroker.ch)

More LIRs can be found at [Networking: IPv6 Discord server](https://discord.gg/ipv6).

## Prerequisites

1. Money.
2. Credit card or prepaid card.
3. Valid government ID.
4. Account at [RIPE NCC Access](https://access.ripe.net/registration).
5. Your chosen LIR.

## Buying your ASN

I have chosen Lagrange Cloud since their ASN registration is cheap, one-off fee, and they have a guided ASN registration for beginners. They also provide a free /48 IPv6 prefix for 1 year.\
Buying an ASN from Lagrange Cloud feels like just buying a domain name.

1. Create an account at your LIR. For this example, my LIR is Lagrange Cloud.
2. Create ASN and input your payment details.
3. Input your information.\
They will ask you for 2 peering details. This will be the ASN of iFog GmbH (Since I will use their IPv6 only VPS to announce my IPv6 prefix), and ASN of Lagrange Cloud.
   1. AS34927 | noc@ifog.ch
   2. AS209735 | noc@lagrange.cloud
4. Create an account at [RIPE NCC Access](https://access.ripe.net/registration). This allows you to create objects at the RIPE database.
5. Lagrange Cloud will guide you on what to create on RIPE database like maintainer, role, person, and organisation.
6. For persons who are outside Europe, attach an invoice for a VPS that is located in Europe.\
Since I was located outside Europe, I brought an IPv6 only VPS in [iFog GmbH](https://my.ifog.ch/order/main/packages/ipv6-only-vps/?a=MTUyNQ==) and uploaded its invoice.\
This IPv6 only VPS will also be used for announcing my ASN and IPv6 later.
7. Wait for around 2 business days, and they will ask you to sign an End User Assignment Agreement and sign it. They will also verify your ID.
8. Wait for around 2 business days, and they will email you saying that your ASN and /48 IPv6 prefix are assigned.

Now that we have an ASN, it is time to [set up the ASN](../my-asn-journey-setting-up-your-own-asn/).