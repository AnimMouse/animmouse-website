---
title: Chihaya torrent tracker on Heroku
date: 2022-07-24T18:03:31+08:00
lastmod: 2022-08-27T01:39:00+08:00
categories:
  - projects
---
[Chihaya on Heroku](https://github.com/AnimMouse/chihaya-heroku)

Chihaya HTTP torrent tracker tunneled from a worker dyno using [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared).

## Purpose
I wanted to see if Heroku is viable in running a HTTP based torrent tracker, but running a torrent tracker will heavily strain the Heroku's HTTP routers with that so many requests.

Others have ran a torrent tracker on Heroku, but they got shut down due to the number of HTTP requests.

So what I did is to bypass the Heroku's HTTP routers by using a tunnel to Cloudflare.

Also to use the remaining years of the 120181311.xyz domain that was used on Atrack torrent tracker.

## Status
The torrent tracker was started on 2022-02-21, with the inclusion of the tracker in [newTrackon](https://newtrackon.com).

On 2022-03-06, I converted to worker dyno instead of web dyno so that the tracker will not shut down if the metrics webpage did not get any HTTP requests.

The announce interval was set from 15 minutes to 3 hours on 2022-04-10 to lessen the bandwidth from 1.07 TB per month, to 13.41 GB per month.

On 2022-04-23, tracker goes down due to free dyno hours got exhausted due to my other apps, Cloudflare got a nice 3.21 TB bandwidth per day from serving Cloudflare Tunnel error 1033.\
Tracker has been moved to a separate account to prevent being shut down.

The torrent tracker has been decommissioned on 2022-08-13, with the expiration of the 120181311.xyz domain.

During the grace period, the IP address was pointed to Namecheap's parking page, their servers are facing the brunt of requests by torrent clients.