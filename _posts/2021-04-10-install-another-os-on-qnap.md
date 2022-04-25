---
layout: post
title:  "Install another OS on to a QNAP NAS"
---
I saw someone else on [r/QNAP install Windows Server on their TS-253Be](https://www.reddit.com/r/qnap/comments/fndgcr/windows_server_2012_and_2016_works_on_ts253be/) a while ago, and I really wanted to do the same with my TS-453Be, so I'm writing this guide to show others what I've done. This should work with TrueNAS/FreeNAS/BSD, Linux or Windows; basically any x86_64 operating system.<!--more-->

#### Preperation
* You will need at least 2 USBs, 1 for the installer and one to install to (this one should be fairly high quality, eg. an SSD), unless you are installing to one of the bays.
* You will also need a monitor, keyboard and optionally a mouse.

#### Optionally Backup the Flash
You shouldn't need to touch the flash, and it's not really useful since it's only 4GB, but if something happens you can restore it and get back to QTS.
* While in QTS or in a live Linux USB run `cat /dev/mmcblk0 > qnapmmc` and save the output file ('qnapmmc') in a safe place
* To restore the file run `cat qnapmmc > /dev/mmcblk0` from a live Linux USB such as [Ubuntu](https://ubuntu.com/download/desktop).

#### Setting up the BIOS
1. Shutdown the NAS, plug everything in, then start it up
2. While the NAS is starting mash (or hold) the `DEL` (or `ESC`) key which will let you get into the BIOS

    [![BIOS](/assets/img/articles/QNAP/QNAP-BIOS.gif){:width="50%"}](/assets/img/articles/QNAP/QNAP-BIOS.gif)
3. When in the BIOS you will want to re-arrange the boot order to make sure that the NAS will start whatever you are installing, eg. Installer first, other drive second, disable or move 'QNAP OS' so isn't going to start up
    
    Default Boot Order | My Boot Order
    --- | ---
    [![Default Boot Order](/assets/img/articles/QNAP/QNAP-BIOS1.jpg)](/assets/img/articles/QNAP/QNAP-BIOS1.jpg) | [![My Boot Order](/assets/img/articles/QNAP/QNAP-BIOS2.jpg)](/assets/img/articles/QNAP/QNAP-BIOS2.jpg)
4. Save Changes and Reset

    [![BIOS](/assets/img/articles/QNAP/QNAP-BIOS3.jpg){:width="50%"}](/assets/img/articles/QNAP/QNAP-BIOS3.jpg)
5. The NAS should boot to the installer, and you can install from there.

#### Additional Notes
* My TS-453Be doesn't support booting from NVMe since I have a QM2, you can only boot from USB, the first 2 bays or the flash.
* When installing to USB you should setup 2 USB drives as a mirror so if one dies you don't have to reinstall or lose any data.
* If your multigigabit NIC doesn't work with TrueNAS, add `if_atlantic_load=YES` to your tunables, running `kldload if_atlantic.ko` can be used to temporarily load the driver if you have no network connectivity.
* There is also a [really old guide to installing debian on a QNAP](https://wiki.qnap.com/wiki/Debian_Installation_On_QNAP).
