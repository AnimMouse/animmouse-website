---
title: 'My ASN Journey: Setting up RPKI'
description: How to set up RPKI ROA on your prefix and enable RPKI route filtering
date: 2024-05-20T00:02:00+08:00
tags:
  - ASN
  - BGP
  - IPv6
  - tutorials
draft: true
---
Resource Public Key Infrastructure (RPKI)'s Route Origin Authorizations (ROAs) is like a route6 object found in the Internet Routing Registry (IRR), but with the added security since only those who has the private key for the prefix can make and sign ROAs.

Anyone can make a route6 object for a given ASN and prefix, but making ROAs requires someone who has the private key to make it.

## Set up RPKI ROA on your prefix

RPKI ROA for your prefix can either be made using your LIR's panel or by opening a support ticket. In my case and for this tutorial, I requested Lagrange Cloud, my LIR, to make a ROA for my prefix via their panel.

## Set up RPKI route filtering