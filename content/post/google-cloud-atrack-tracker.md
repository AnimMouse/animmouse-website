---
title: "Google Cloud response to Atrack Tracker"
description: "What will happen if you run a torrent tracker on Google"
date: 2021-06-02T23:53:11+08:00
tags:
  - Google App Engine
  - Google Cloud Platform
---
## What will happen if you run a tracker on Google App Engine while paying for it.
Google contacted us because they said that [Atrack Tracker](https://github.com/AnimMouse/atrack) is exceeding its quota aggressively.\
They also disabled the app, and they did not enable it so we decided to change project name to continue running the torrent tracker.\
This only happened when we enabled billing, this does not happen on free tier.

On July 28, 2018, 2:50 AM\
Subject: Action required: Your product has exceeded quota
> Hello Anim Mouse,
> 
> This is *redacted* from Google Cloud Platform - Technical Solutions Engineering. I am contacting you regarding your project atrack-torrent-tracker and that you app is exceeding its quota aggressively enough to cause excess load on the traffic balancing mechanisms in App Engine, pushback in this case, and appears a torrent tracker app (by name).
> 
> To safeguard our systems, your project has been disabled.
> 
> I would strongly recommend that you to review your app and make sure it does not aggressively exceed its quota allotment.
> 
> Please let me know how you wish to proceed, and thank you for your understanding.
> 
> Sincerely,
> 
> Google Cloud Support

My reply on July 30, 2018, 11:12 PM
> Hello *redacted*,
> 
> Thank you for contacting us what happened in our app and we will be reviewing our app in order to make sure that we will not cause excess load in the Google's infrastructure.
> 
> We request to enable our app in order to know what's happening in our app, thank you for your understanding.
> 
> And by the way, I cannot access the link you provided because it always says that "You need permission to access the Google Cloud Support Center."

Their reply on July 31, 2018, 8:02 AM
> Hello Anim Mouse,
> 
> My name is *redacted* from Google Cloud Platform Support. I'm taking over this case since *redacted* is out the office.
> 
> I read your message requesting us to enable your application to let you investigate what caused the excess in the traffic.
> 
> If I request at this moment to the App Engine Specialists that your application be enabled and the issue persists, it will be disabled again in a short period of time.
> 
> Is it possible you debug your application on your development environment as stated in [1]? In the section "Why did my app get disabled?" they recommend use Google Cloud SDK (development SDK).
> 
> I'll be looking to your reply.
> 
> Sincerely,
> 
> *redacted*\
> Technical Solution Representative\
> Google Cloud Platform Support, Mexico

My reply on August 2, 2018, 7:20 PM
> Hello *redacted*,
> 
> We have already used the development SDK to test our app in our local computer, but the problem is, we cannot simulate millions of computers requesting on our app in the same place at the same time, so we don't know the problem yet.
> 
> And from the Google Stackdriver logs we had, it seems like someone is DDoSing us because this happened before that our app reached 13.3GB of outgoing bandwidth in just 6 hours. We normally operate under the 1GB quata. And this happened again this time, the app got caught and disabled by Google.
> 
> We also request to enable our app in order to know what's happening in our app, thank you for your understanding.

Their reply on August 8, 2018, 1:08 AM
> Hello Anim Mouse,
> 
> App Engine team is working on re-enabling your application. They recommend you take next actions to prevent your application be disabled again:
> 
> 1. Update your scaling configuration in order to scale up when required and handle more appropriate number of requests. This will require you deploy a new version of your application once it gets enabled.
> 2. If you suspect you are a victim of DDoS attack then it is strongly recommended you front your application with a DDoS protect solution. You can look at [1] and [2] for more information about the solutions offered in GCP such as Cloudflare and Cloud Armor. Also, you may want to consult the information in [3] regarding Controlling Access with Firewalls.
> 
> I will be in touch with the App Engine team and let you know when I have an update of the status of your application. Please let me know if you have any questions.
> 
> Regards,
> 
> *redacted*\
> Technical Solution Representative\
> Google Cloud Platform Support, Mexico

Their reply on August 8, 2018, 8:50 AM
> Hello Anim Mouse,
> 
> This message is just to let you know that your App Engine services have been re-enabled. Please let me know if you have any questions about the recommendations I provided in my previous email.

At this point they re-enabled Atrack tracker and we started debugging.

Their reply on August 9, 2018, 7:10 AM
> Hello Anim Mouse,
> 
> I was just looking how to improve our communication in this case. Looking at our messages seems we might have different time zones. So it would be useful your provide a contact number and a timezone in that way I can determine if one of our sites in another region can handle this case providing faster responses.
> 
> By the way, after I inspect your project I noticed the billing is disabled. Please enable it to prevent any new interruption in your service.
> 
> I'll be looking forward to your reply.
> 
> Regards,
> 
> *redacted*\
> Technical Solution Representative\
> Google Cloud Platform Support, Mexico

At this point they disabled Atrack tracker again.

My reply on August 9, 2018, 11:13 PM
> Hello *redacted*,
> 
> My time zone is UTC+08:00 (Philippines) and it seams like our project is disabled again. We intentionally disabled billing in order for the app not to exceed its quota aggressively again if it hits the free usage quota, but as of now, we don't know why Google disabled our app again. We have already reviewed and tested our code in the development SDK but we don't really know (Platform as a service limitation) why our app causes excess load on the traffic balancing mechanisms in App Engine.
> 
> Please let use know why our app causes excess load on the traffic balancing mechanisms in App Engine, and thank you for your understanding.

Their reply on August 11, 2018, 10:12 AM
> Hello Anim Mouse
> 
> This is *redacted*, and I am taking care of this case since *redacted* is out of the office.
> 
> Per further checking, you already exceeded the free quota where you consumes all of an allocated resource on your application. Kindly check our quota page[1] for more details.
> 
> In this regard, Can you perhaps provide your phone number so we can contact you to coordinate turning the app back on. We may need to work with you to avoid happening this again.
> 
> Furthermore, at this point, we are not certain why you are receiving so much traffic, and we believe you have insight into that, can you explain?
> 
> Please note that turning the app back on presents a risk to other customers in the region.
> 
> Looking forward for your response.
> 
> Kind Regards,\
> *redacted*\
> Google Cloud Platform Support, Manila

Well, it seems that running a torrent tracker will receive that so much traffic, haha.

Their reply on 	August 14, 2018, 10:29 AM 
> Hello Anim Mouse,
> 
> Greetings! I haven't heard back from you in a while.
> 
> Just want to bubble this up to the top of your inbox-- have you had a chance to check my previous message?Were you able to provide your phone number so we can contact you to coordinate turning the app back on.
> 
> I was very much looking forward to hearing back.
> 
> I'll be waiting for your reply and will keep this open for another 48 hours (before closure) so you may have ample time to check.  Should you miss the given window, feel free to reopen the case by replying here within 30 days thereafter.
> 
> Kind Regards,\
> *redacted*\
> Google Cloud Platform Support, Manila

My reply on August 14, 2018, 11:16 PM
> Hello *redacted*,
> 
> We have a phone number but the problem is, we are busy doing things around here and we can't actively contact you in real time. If you really needed our phone number, we can give it.
> As a public torrent tracker, we expect a lot of request because lots of people are using our tracker and because of that, we choose Google App Engine because we believe that Google's infrastructure can handle lots of traffic coming from people that uses torrent (not on this case, haha, the reason they disabled our tracker).
> Because you said that turning the app back on presents a risk to other customers in the region, we consider moving our app to another region. In order to do that, we request to re-enable our app in order to us to backup our data and settings and create another project in another region and put it there.
> 
> And we're sorry that we replied late, because of the weather in Manila in the past days, and thank you for your understanding.

At this point, I no longer receive any reply, and the app is still disabled, so we decided to shutdown the app and move to another project name.

> Your Google Cloud Platform project atrack-torrent-tracker was shut down on 2018-08-21T01:46:20+00:00.
> 
> If you take no action, after 2018-09-20T01:46:20+00:00, you will be unable to recover this project. If this was unintentional, visit this URL before 2018-09-20T01:46:20+00:00 to cancel the project shutdown:
> 
> https://console.developers.google.com/project?pendingDeletion=true&organizationId=0
> 
> If you have any questions, please visit the Developers Console Help at this URL, or contact support:
> 
> https://developers.google.com/console/help/new/
> 
> Thanks,
> The Google Developers Console Team