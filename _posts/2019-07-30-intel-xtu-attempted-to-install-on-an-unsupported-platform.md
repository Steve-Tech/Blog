---
id: 1200
title: 'Intel XTU ‘Attempted to install on an unsupported platform’'
date: 2019-07-30T19:50:47+10:00
author: SteveTech
layout: post
guid: /?p=1200
permalink: /2019/07/30/intel-xtu-attempted-to-install-on-an-unsupported-platform/
onesignal_meta_box_present:
  - "1"
  - "1"
onesignal_send_notification:
  - ""
  - ""
ampforwp_custom_content_editor:
  - ""
  - ""
ampforwp_custom_content_editor_checkbox:
  - ""
  - ""
ampforwp-amp-on-off:
  - default
  - default
uuid:
  - c81366c2-6742-bd7b-6b35-0ff3e5a2727f
  - c81366c2-6742-bd7b-6b35-0ff3e5a2727f
response_body:
  - '{"id":"7f8feed5-f498-4a55-a6f2-68bb177109bb","recipients":109,"external_id":"c81366c2-6742-bd7b-6b35-0ff3e5a2727f","warnings":["You must configure iOS notifications in your OneSignal settings if you wish to send messages to iOS users."]}'
  - '{"id":"7f8feed5-f498-4a55-a6f2-68bb177109bb","recipients":109,"external_id":"c81366c2-6742-bd7b-6b35-0ff3e5a2727f","warnings":["You must configure iOS notifications in your OneSignal settings if you wish to send messages to iOS users."]}'
status:
  - "200"
  - "200"
recipients:
  - "109"
  - "109"
notification_id:
  - 7f8feed5-f498-4a55-a6f2-68bb177109bb
  - 7f8feed5-f498-4a55-a6f2-68bb177109bb
amp-cf7-form-checker:
  - "1"
  - "1"
categories:
  - Tutorials
---
I was recently wanting to mess around with the CPU clocks on my laptop which is a Surface Book 2 using Intel Extreme Tuning Utility, but whenever I tried to install it I was greeted by an error dialogue that said ‘Attempted to install on an unsupported platform’. This is how I fixed it&#8230;

  1. Download the official [Intel XTU](https://downloadcenter.intel.com/download/24075/Intel-Extreme-Tuning-Utility-Intel-XTU-)
  2. Open it until you get to the error but do not close it
  3. Open File Explorer to ‘C:\ProgramData\Package Cache’ and search for ‘xtu’ look for something named ‘Intel_XtuInstaller.msi’, ‘XTUInstaller.msi’ or something similar
  4. Copy it to a safe place (ie. your Desktop or Documents)
  5. Open CMD to the directory you copied the .msi file to (You can type cmd in the address bar to do this automatically) and type in `msiexec /i Intel_XtuInstaller.msi DISABLEPLATFORMCHECK=1`
  6. You have to restart your laptop otherwise you will get an error along the lines of ‘the drivers are not present’ (trust me I’ve tried)