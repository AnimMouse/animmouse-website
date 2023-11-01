---
title: Why DANE failed
description: Why DNS-based Authentication of Named Entities failed to take over and what we can do
date: 2022-03-04T15:38:58+08:00
tags:
  - dev
  - essay
---
DNS-based Authentication of Named Entities (DANE) is a way to authenticate TLS client and server entities without a certificate authority (CA).

Since certificate authorities within the last few years suffered serious [security breaches](https://en.wikipedia.org/wiki/Certificate_authority#CA_compromise), I'm fond of the idea of removing certificate authorities in the trust chain and allows us to create certificate for our server for free by using self-signed cert and applying it to TLSA record. DANE is a proposed solution to that problem by using Domain Name System Security Extensions (DNSSEC) as a way to authenticate TLS clients and servers.

But it is 2022 already and yet there is still no browser and website support for DANE, why it failed to take over? Have we solved the problem that traditional CA system creates?

1. For CAs, DANE does not remove certificate authorities, what it did is instead of having independent CAs, DANE moved the responsibility of the CAs to the domain name registry, thus making the registries the certificate authorities.

Since DANE uses DNSSEC as a way to verify the clients and servers, the authorities that manages the DNSSEC keys like the top-level domains (TLDs) registries like Verisign for .com and ultimately the . DNS root servers are the one that makes the verification.

In a traditional CA system, if you have a domain name example.com, and you want SSL for your website, you have a lot of CAs to choose from. For example, if CA DigiCert did not accept your application for a certificate, then you instead buy in CA Comodo or if you want SSL for free, then you go to CA Let's Encrypt.
In DANE, since the TLD of example.com is .com which is managed by Verisign, what if Verisign did not sign your DNSSEC zones? Then you don't have SSL for your website. You can't also choose another registry unless you change to another TLD like example.xyz.

Also, we have country code top-level domain (ccTLD) that is managed by the respective countries. The trust anchor is placed on the respective governments itself. And many of those governments do not trust each other. That would be a political nightmare on the internet.

And don't forget the Internet Assigned Numbers Authority (IANA) that holds the . DNS root server keys, you can't simply create your own DNS root server unlike in traditional CA, don't trust US? (Where IANA is based), then simply create your own CA.

The only way to have more CAs in DANE is to have more TLDs, and the only CA you can have for a single TLD like .com is the one that manages .com: Verisign, unlike in traditional CA that you can choose CAs you want. Or even better, you can be your own CA, just like what Google is doing with their own Google Trust Services. In DANE, the only way for Google to have their own CA is to have the .google TLD.

2. For free certificates, we have Let's Encrypt that provides free domain validated certificates, eliminating the need for DANE for free certificates.

So what we can do? Is DANE dead? No, DANE still exists, and most commonly used in SMTP servers.

If you have a website and you can enable DNSSEC and DANE, go for it, even though no browser supports it.

References:
1. [DANE political problems](https://www.securityweek.com/convergence-replacement-throwdown-dane-vs-tack-vs-ct)
2. [DANE only trust ICANN](https://easydns.com/blog/2015/08/06/for-dnssec/#dane)