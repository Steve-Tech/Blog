---
layout: post
title:  "Using an SR-IOV Network Interface in a Proxmox LXC"
---

For fun I was trying to work out how I could use an SR-IOV Interface for my LanCache container. Since it would let me run it with very low disk overhead, compared to a VM, and low network overhead compared to a virtual bridge; I am aware that this probably doesn't affect much though.<!--more-->
Also, after running an iperf, it still isn't as fast as on the host, or a VM with PCIe passthrough, but it's seems slightly faster than a virtual bridge.

Firstly you need to have SR-IOV enabled and working, and also have the VF's showing up on the host, eg. interfaces similar to `ens6f0v2` showing up in `ip a`.

Since as you may have noticed, proxmox doesn't support this in the UI so you're going to have to add these to the LXC's config (`nano /etc/pve/lxc/<ct-id>.conf`).

```r
lxc.net.0.type: phys
lxc.net.0.link: ens6f0v32  # Replace with your VF interface
lxc.net.0.flags: up
lxc.net.0.ipv4.address: 192.168.0.111/24  # Replace with your IP
lxc.net.0.ipv4.gateway: 192.168.0.1  # Replace with your Gateway
lxc.net.0.name: eth0  # Not needed, but it makes things easier
# lxc.net.0.mtu: 9000  # Enable Jumbo Frames, doesn't work on my NIC
```

Depending if you've already got a network interface in the container, you may need to change the `lxc.net.0` to `lxc.net.1` or higher. Then you can start the container and your interface should show up in the container's `ip a`:

```text
root@lancache:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
299: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 0a:5b:a7:31:6d:4c brd ff:ff:ff:ff:ff:ff
    altname enp129s0f0v32
    inet 192.168.0.111/24 brd 0.0.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2001:<removed>/64 scope global dynamic mngtmpaddr 
       valid_lft 49244sec preferred_lft 49244sec
    inet6 fe80::85b:a7ff:fe31:6d4c/64 scope link 
       valid_lft forever preferred_lft forever
```

Sources:
- [LXC Manpages - lxc.container.conf.5](https://linuxcontainers.org/lxc/manpages/man5/lxc.container.conf.5.html#lbAO)
- [[SOLVED] - PVE 4.1 how to passthrough Nic to LXC](https://forum.proxmox.com/threads/pve-4-1-how-to-passthrough-nic-to-lxc.25686/)
- [Physical NIC assignment for LXC containers in Proxmox 7.2](https://forum.proxmox.com/threads/physical-nic-assignment-for-lxc-containers-in-proxmox-7-2.109981/)