---
layout: post
title:  "Where you can find ARM64 LXC Templates"
---

I was just experimenting with [Pimox](https://github.com/pimox/pimox7) on a Raspberry Pi 4 and was wondering where I could download the ARM64 LXC templates for [Proxmox](https://www.proxmox.com/).<!--more-->

#### [Canonical Image Server](https://uk.lxd.images.canonical.com/images/)
URL: [https://uk.lxd.images.canonical.com/images/](https://uk.lxd.images.canonical.com/images/)

Click on a distro and version then navigate to `arm64/default/<build date>/`

Just copy the link for `rootfs.tar.xz` and paste it in the 'Download from URL' dialog thats in proxmox's storage then 'CT Templates'.

If you like you can also copy the SHA-256 Hash for rootfs.tar.xz from `SHA256SUMS` and paste it in the 'Checksum' input, making sure to select the SHA-256 'Hash algorithm'.

Alternatively you can wget it to `/var/lib/vz/template/cache/` or `/mnt/pve/<storage>/template/cache/`

#### [linuxcontainers.org Jenkins server](https://jenkins.linuxcontainers.org/view/Images/)
URL: [https://jenkins.linuxcontainers.org/view/Images/](https://jenkins.linuxcontainers.org/view/Images/)

When I first checked Canonical only seemed to have Debian, I don't know why, the folders were there they were just empty?

Click on a distro, click on a version under arm64 & default, copy the link for `rootfs.tar.xz` and paste it in the 'Download from URL' dialog thats in proxmox's storage then 'CT Templates'.

Alternatively you can wget the link to `/var/lib/vz/template/cache/` or `/mnt/pve/<storage>/template/cache/`