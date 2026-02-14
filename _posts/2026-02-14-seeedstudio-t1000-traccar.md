---
layout: post
title:  "How to use a SeeedStudio T1000 with Traccar"
---

The SeeedStudio T1000-A/B is a LoRaWAN-based GPS tracker that can be used with the Traccar GPS tracking platform when paired with The Things Network (TTN). In this post, I will show you how to set up the T1000 with TTN and Traccar.

<!--more-->

#### Initial Setup

You can follow the official instructions on the SeeedStudio wiki to set up your T1000 with TTN: [SeeedStudio T1000 LoRaWAN GPS Tracker](https://https://wiki.seeedstudio.com/SenseCAP_T1000_tracker_TTN/). This will involve creating an account on TTN, registering your device, and configuring the device to connect to TTN.

If you haven't already setup Traccar, you can follow their official quick start guide: [Traccar Quick Start Guide](https://www.traccar.org/quick-start/).

#### Setting up the Payload Formatter on TTN

Once your device is sending data to TTN, you will need to set up a payload formatter to convert the raw data from the T1000 into a format that Traccar can understand. SeeedStudio's default payload formatter is not compatible with Traccar, so you will need to specify a custom payload formatter.

I have created a custom payload formatter that converts the T1000's payload into a simple JSON format that Traccar can parse:

<script src="https://gist.github.com/Steve-Tech/c572309397592f994efe376c046f6f68.js"></script>

[View Payload Formatter on GitHub Gist](https://gist.github.com/Steve-Tech/c572309397592f994efe376c046f6f68)

Alternatively, you can use [SeeedStudio's TTN Mapper payload formatter](https://wiki.seeedstudio.com/ttn_mapper_for_SenseCAP_T1000/), but that will only display your latitude and longitude, and not any of the sensors or additional information such as battery level or alarms.

#### Setting up the TTN Webhook for Traccar

Traccar listens for the TTN webhook on port `5261`, so you will need to make sure that port is accessible from the internet. You can also use a reverse proxy to achieve this (e.g. I personally use `https://traccar-api.example.com/ttn` with an API key, but I will only cover the basic setup here). Traccar also only understands JSON currently, and we only want to send uplink messages, so you should configure the webhook like so:

![TTN Webhook Configuration](/img/articles/seeedstudio-t1000-traccar/ttn-traccar-webhook.png){: .rounded}

* **Webhook ID**: This can by anything you want, I use `traccar`.
* **Webhook format**: This should be set to `JSON`.
* **Base URL**: This should be the URL of your Traccar server, e.g. `http://traccar.example.com:5261`.
* **Enabled event types**: You should only select `Uplink message` here, leave the rest unchecked. The path doesn't matter, as Traccar will ignore it and just listen for any incoming requests on that port.

#### Setting up the Device in Traccar

Finally, you will need to add your device to Traccar. You can do this by going to the Traccar web interface, and clicking on the plus (**+**) icon. The identifier needs to match the 'End device ID' you set on the TTN console when you registered your device. You can set the device name and other information as you like.

You should now start seeing data from your T1000 in Traccar! Remember that you will need to wait until it's next upload interval.

#### Affiliate Links

If you are interested in purchasing a SeeedStudio T1000, you can use the following affiliate links to support my work:

* [SeeedStudio T1000-A (with sensors)](https://www.seeedstudio.com/SenseCAP-Card-Tracker-T1000-A-p-5697.html?sensecap_affiliate=WpDECrz)
* [SeeedStudio T1000-B (without sensors)](https://www.seeedstudio.com/SenseCAP-Card-Tracker-T1000-B-p-5698.html?sensecap_affiliate=WpDECrz)

I run no external ads on this blog, and I spent my own money on my T1000-A, so if you found this guide helpful and want to support me, please consider using the affiliate links above. It doesn't cost you anything extra, but it incentivises me to [improve LoRaWAN support in Traccar](https://github.com/traccar/traccar/pull/5708), as well as the guides of course.
