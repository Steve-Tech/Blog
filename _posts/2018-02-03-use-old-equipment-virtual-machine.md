---
id: 783
title: How to use old Equipment with a Virtual Machine
date: 2018-02-03T09:01:45+10:00
author: Steve-Tech
layout: post
guid: /?p=783
permalink: /2018/02/03/use-old-equipment-virtual-machine/
categories:
  - Tutorials
tags:
  - Devices
  - Equipment
  - Virtual Machine
  - VM
  - VMware
---
I have an old slide scanner that only works with Windows 98 and I was wondering if I could use it again to scan some slides and I tried using [Oracle VM VirtualBox](https://www.virtualbox.org/) with Windows 98 to connect to it but it wouldn’t detect the scanner but then I found [VMware Workstation Player](https://www.vmware.com/products/workstation-player.html) and it worked great<!--more--> probably because it looked for the device then unmounted the device from the ‘Host’ and connected it to the ‘Guest’ and I’m going to show you how to do it yourself.

{%- include adsense-inarticle.html -%}

* * *

### Stuff to get beforehand

  * Just Download [VMware Workstation Player](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html) and that’s it

### Steps

  1. Plug in the device you want to use into your computer and open VMware Workstation Player
  2. Find an image of Windows 98 ([here](https://winworldpc.com/product/windows-98/98-second-edition)) or the version that works with your device and Install it in VMware Workstation
  3. Connect the device to your Virtual Machine<img class="aligncenter wp-image-921 size-full" src="/assets/2018/01/Windows-98-VM-Connect.png" alt="" width="900" height="420" />
  4. Install any needed Drivers and your done