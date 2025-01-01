---
title: 'My ASN Journey: Setting up IP geolocation'
description: How to set up IP geolocation on your prefix via geofeed
date: 2025-01-02T01:02:00+08:00
tags:
  - ASN
  - BGP
  - IPv6
  - tutorials
---
A geofeed is a CSV file where you set the geolocation for a specific IP prefix.\
Geolocation providers will use your geofeed in order to set the location of your IPv6 address in their database.

It must be hosted on a web server and be declared on the `inet6num` object's `geofeed:` field.

## Create a geofeed.csv file

Format:\
`network, iso_country code, iso_region_code, city_name, postal_code`

Example:
```csv
2a0a:6044:accd::/48,PH,PH-00,Manila,1000
```

## Hosting your geofeed.csv file

You can host your geofeed.csv file on your web server, GitHub Pages, jsDelivr, etc.

### Example

* Hosted on GitHub Pages: `https://as.215150.xyz/geofeed.csv`
* Hosted on GitHub Repository via jsDelivr: `https://cdn.jsdelivr.net/gh/AnimMouse/AS215150/geofeed.csv`

## Declare geofeed.csv on inet6num

1. Go to the [RIPE database's My Resources (IPv6)](https://apps.db.ripe.net/db-web-ui/myresources/overview?type=inet6num).
2. Click on your IPv6 prefix.
3. Click Update object.
4. At the country attribute, click the + (plus) icon.
5. Select geofeed, and click add.
6. On geofeed, input your geofeed.csv URL.\
Example URL:
`https://as.215150.xyz/geofeed.csv`

## Test geofeed.CSV

Check if your geofeed is declared properly by using [Geolocate much?](https://geolocatemuch.com) and input your IPv6 address there.

After declaring your geofeed.csv, geolocation service providers will automatically fetch your geofeed and update their database.