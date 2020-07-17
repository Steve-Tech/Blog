---
id: 717
title: How to convert a Physical Disk to a VMware VMDK image
date: 2018-01-07T09:04:48+10:00
author: SteveTech
layout: post
guid: https://jas-team.net/?p=717
permalink: /2018/01/07/convert-physical-to-vmdk/
onesignal_meta_box_present:
  - "1"
  - "1"
onesignal_send_notification:
  - ""
  - ""
dsq_thread_id:
  - "6396353048"
  - "6396353048"
bs_social_share_facebook:
  - "0"
  - "0"
bs_social_share_twitter:
  - "0"
  - "0"
bs_social_share_reddit:
  - "0"
  - "0"
bs_social_share_google_plus:
  - "0"
  - "0"
bs_social_share_interval:
  - "1525875672"
  - "1525875672"
ampforwp_custom_content_editor:
  - ""
  - ""
ampforwp_custom_content_editor_checkbox:
  - ""
  - ""
ampforwp-amp-on-off:
  - default
  - default
amp-cf7-form-checker:
  - "1"
  - "1"
amp-page-builder:
  - ""
categories:
  - Tutorials
tags:
  - Convert
  - HDD
  - Physical
  - VMDK
  - VMware
---
I was recently wanting to convert all of my old hard drives from old computers to VMDKs so that I could run the drive virtually in VMware, but I couldn&#8217;t find a way to do it so that&#8217;s why I&#8217;m writing this now.<!--more--> Most other guides would use Disk2vhd and use Hyper-V but most people don&#8217;t have a pro version of Windows to use that or some guides would say to use VMware vCenter Converter but the physical machine has to be running and I only have the hard drive so I can&#8217;t use that. Then I found StarWind V2V Converter which can convert a VHD (and VHDX) file from Disk2vhd and that&#8217;s what this guide is going to use.

* * *

### Stuff to get beforehand

  * Download <a href="https://docs.microsoft.com/en-us/sysinternals/downloads/disk2vhd" target="_blank" rel="noopener noreferrer">Disk2vhd</a> and <a href="https://www.starwindsoftware.com/converter" target="_blank" rel="noopener noreferrer">StarWind V2V Converter</a> (or click this <a href="https://www.starwindsoftware.com/tmplink/starwindconverter.exe" rel="noopener">link to download StarWind V2V Converter</a> without giving your info away).
  * Buy a SATA (or IDE) to USB adapter to easily connect the old hard drive to your computer.

* * *

### Steps

#### UPDATE

**(12/05/2018):** I&#8217;ve recently found [Vmdk2Phys](https://sourceforge.net/projects/vmdk2phys/) which is still in beta (and doesn&#8217;t look the best) but is more straightforward then following the guide below. [Vmdk2Phys](https://sourceforge.net/projects/vmdk2phys/) also supports converting VMDKs to physical drives.

  1. Open Disk2vhd and untick all volumes except the one you want to virtualize and pick a location to output the file to, then click the &#8216;Create&#8217; button. It will take a while to finish depending on the size and speed of your drive.<img class=" size-full wp-image-761 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/Disk2vhd.png" alt="Disk2vhd" width="511" height="355" />
  2. Once Disk2vhd finishes open StarWind V2V Converter select &#8216;Local file&#8217; and click &#8216;Next >&#8217; when it asks for the &#8216;Source image location&#8217;<img class="size-full wp-image-762 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-Image-location.png" alt="StarWind V2V Converter - Image location" width="565" height="478" />
  3. Select the &#8216;Source image&#8217; then click &#8216;Next >&#8217;<img class="size-full wp-image-784 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-Source-image.png" alt="StarWind V2V Converter - Source image" width="565" height="478" />
  4. Select the format you want to convert to (the 1st and 3rd option are probably the most compatible option with VMware Workstation Player)<img class="size-full wp-image-785 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-Destination-image-format.png" alt="StarWind V2V Converter - Destination image format" width="565" height="478" />
  5. Select the &#8216;Virtual disk type&#8217; (Select the one most compatible with the windows installation eg. IDE for Windows XP)<img class="size-full wp-image-802 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-VMDK-Options.png" alt="StarWind V2V Converter - VMDK Options" width="565" height="478" />
  6. Set your destination file location then click &#8216;Next >&#8217;<img class="size-full wp-image-805 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-Destination-file.png" alt="StarWind V2V Converter - Destination file" width="565" height="478" />
  7. Run the converted file in VMware Workstation Player<img class="size-full wp-image-854 aligncenter" src="https://jas-team.net/wp-content/uploads/2018/01/StarWind-V2V-Converter-Converting-Finished.png" alt="StarWind V2V Converter - Converting Finished" width="565" height="478" />