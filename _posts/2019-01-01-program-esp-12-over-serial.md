---
layout: post
title: How to program a Wemos D1/ESP 12 over TTL Serial
date: 2019-01-01T16:17:49+10:00
---
I recently accidentally shorted one of my Wemos D1 minis and it would no longer be powered over 5v so the USB port was made pretty much useless so I wanted to try and get it working with at least the [ArduinoOTA](https://github.com/esp8266/Arduino/blob/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino) sketch so here is a tutorial on how to program a Wemos D1 mini over the TTL serial pins.

#### Things you need:
So you would need a USB to TTL Serial Adapter or a device with TTL Serial built in such as a Raspberry Pi or an Arduino might work as long as you ground reset and you would also need a few jumper wires to connect everything.

#### Wiring:
GND to D3 (GPIO0) on Wemos/ESP (When Programming/Uploading)  
TX to RX (But if you’re using an Arduino as a USB to TTL adapter do TX to TX)  
RX to TX  
3.3V to 3v3  
GND to GND

Now select the device in the ports menu (in tools) and upload how you normally would and it should normally work. I would recommend uploading the [ArduinoOTA](https://github.com/esp8266/Arduino/blob/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino) sketch so that you don’t need to do this <g class="gr_ gr\_181 gr-alert gr\_spell gr\_inline\_cards gr\_run\_anim ContextualSpelling multiReplace" id="181" data-gr-id="181">everytime</g> and can just program it over WiFi.

<p class="has-small-font-size">
  Also Happy New Year I must have a very boring life to be writing this on new years day.
</p>