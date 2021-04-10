---
layout: post
title:  "Install another OS on to a QNAP TS-453Be, such as TrueNAS"
---
***I'm still writing this guide, images are coming soon.***

I saw someone else on [r/QNAP install Windows Server on their TS-253Be](https://www.reddit.com/r/qnap/comments/fndgcr/windows_server_2012_and_2016_works_on_ts253be/) a while ago, and I really wanted to do the same, so I'm writing this guide to show other's what I've done.

## Preperation
* You will need at least 2 USBs, 1 for the installer and one to install to, unless you are installing to one of the drives.
* You will also need a monitor, keyboard and optionally a mouse.

## Optionally Backup the Flash
You shouldn't need to touch the flash, and it's not really useful since it's only 4GB, but if something happens you can restore it.
* While in QTS or in a live Linux USB run `cat /dev/mmcblk0 > qnapmmc` and save the output file ('qnapmmc') is a safe place
* To restore the file run `cat qnapmmc > /dev/mmcblk0` from a live Linux USB such as [Ubuntu](https://ubuntu.com/download/desktop).

## Setting up the BIOS
1. Shutdown the NAS, plug everything in, then start it up
2. While the NAS is starting mash (or hold) the `DEL` (or `ESC`) keys which will let you get into the BIOS
3. When in the BIOS you will want to re-arrange the boot order to make sure that the NAS will start whatever you are installing, eg. Disable or move 'QNAP OS' so isn't going to start up
4. Save and Reset

## Additional Notes
* My QNAP doesn't support booting from NVMe since I have a QM2, you can only boot from USB, the first 2 bays or the flash.
* When installing to USB you should setup 2 USB drives as a mirror so if one dies you don't have to reinstall or lose any data.
* There is also a [really old guide to installing debian on a QNAP](https://wiki.qnap.com/wiki/Debian_Installation_On_QNAP).