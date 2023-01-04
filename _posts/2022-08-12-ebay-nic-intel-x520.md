---
layout: post
title:  "eBay NIC Review: The Intel X520-DA1 from China"
---
After being unhappy with the compatibility of SR-IOV on other cheap eBay NICs, I recently bought the cheapest Intel X520-DA1 on eBay.
The Intel X520-DA1 is a single port 10 Gigabit SFP+ network card released in 2011 that makes use of the Intel 82599 controller, it takes up 8 PCIe 2.0 lanes and lists compatibility for SR-IOV.
<!--more-->

#### Important Links
[Specifications](https://www.intel.com/content/www/us/en/products/sku/68669/intel-ethernet-converged-network-adapter-x520da1/specifications.html){: .btn .btn-primary}
[Downloads](https://www.intel.com/content/www/us/en/products/sku/68669/intel-ethernet-converged-network-adapter-x520da1/downloads.html){: .btn .btn-primary}

<!-- [Intel Ark](https://ark.intel.com/content/www/us/en/ark/products/68669/intel-ethernet-converged-network-adapter-x520da1.html){: .btn .btn-primary .btn-sm} -->

#### Support
The card has drivers for Windows, Linux, FreeBSD, and VMware. After testing, Debian and FreeBSD have the drivers built in, but FreeBSD seemed to not properly setup the NIC sometimes.
The latest driver that works on Windows (and possibly other OSs) is version [25.6](https://www.intel.com/content/www/us/en/download/15084/30209/intel-ethernet-adapter-complete-driver-pack.html), newer versions faced a similar problem as FreeBSD.

However an important thing to note, is that my card is missing all of the Intel branding as well as shipping from China in a generic box, possibly meaning this is a Chinese clone of the X520-DA1.
I didn't know they existed at the time, but after searching up my problems with FreeBSD and TrueNAS Core, I found [this thread](https://www.truenas.com/community/threads/11-3-rc1-doesnt-like-x520.81502/) where people are discussing the problems they've had.

#### Features
SR-IOV is a big plus for me, essentially it allows you to allocate the NIC to multiple VMs with full hardware acceleration, without loosing access to it on the host.

The NIC doesn't have support for RDMA, but it apparently supports "Storage Over Ethernet" giving it iSCSI and NFS acceleration, or [according to Intel](https://www.intel.com/content/dam/support/us/en/documents/network/sb/10gbe_extremenetworkswp_final.pdf) "The controller enables fast and reliable networked storage with native iSCSI initiator support with Microsoft, Linux, and VMware OSs as well as support for iSCSI remote boot."

Like most SFP+ NICs, this NIC does not feature Wake-On-LAN.

##### `ethtool` output
```
Settings for ens1:
        Supported ports: [ FIBRE ]
        Supported link modes:   10000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  10000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Full
        Auto-negotiation: off
        Port: Other
        PHYAD: 0
        Transceiver: internal
        Supports Wake-on: d
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
```

#### Performance
##### `iperf3` receive from a SFN5122F
```
[  5] local 192.168.0.2 port 39348 connected to 192.168.0.31 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.14 GBytes  9.82 Gbits/sec   30   1.30 MBytes       
[  5]   1.00-2.00   sec   881 MBytes  7.39 Gbits/sec  308    332 KBytes       
[  5]   2.00-3.00   sec   844 MBytes  7.08 Gbits/sec  125   1.49 MBytes       
[  5]   3.00-4.00   sec  1.11 GBytes  9.54 Gbits/sec  111    804 KBytes       
[  5]   4.00-5.00   sec   706 MBytes  5.92 Gbits/sec  231   1.29 MBytes       
[  5]   5.00-6.00   sec  1.15 GBytes  9.90 Gbits/sec    0   1.43 MBytes       
[  5]   6.00-7.00   sec  1.15 GBytes  9.89 Gbits/sec   31   1.33 MBytes       
[  5]   7.00-8.00   sec  1006 MBytes  8.44 Gbits/sec  182    105 KBytes       
[  5]   8.00-9.00   sec  1014 MBytes  8.50 Gbits/sec    9   1.54 MBytes       
[  5]   9.00-10.00  sec  1.15 GBytes  9.88 Gbits/sec    0   1.54 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  10.1 GBytes  8.64 Gbits/sec  1027             sender
[  5]   0.00-10.00  sec  10.1 GBytes  8.63 Gbits/sec                  receiver
```

##### `iperf3` send to a SFN5122F
```
[  5] local 192.168.0.31 port 52374 connected to 192.168.0.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.13 GBytes  9.70 Gbits/sec    0   1.41 MBytes       
[  5]   1.00-2.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.72 MBytes       
[  5]   2.00-3.00   sec  1.13 GBytes  9.70 Gbits/sec    0   1.86 MBytes       
[  5]   3.00-4.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
[  5]   4.00-5.00   sec  1.13 GBytes  9.68 Gbits/sec    0   1.86 MBytes       
[  5]   5.00-6.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
[  5]   6.00-7.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
[  5]   7.00-8.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
[  5]   8.00-9.00   sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
[  5]   9.00-10.00  sec  1.13 GBytes  9.69 Gbits/sec    0   1.86 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  11.3 GBytes  9.69 Gbits/sec    0             sender
[  5]   0.00-10.00  sec  11.3 GBytes  9.69 Gbits/sec                  receiver
```

##### `iperf3` bidir with a SFN5122F
```
[ ID][Role] Interval           Transfer     Bitrate         Retr  Cwnd
[  5][TX-C]   0.00-1.00   sec  1.10 GBytes  9.48 Gbits/sec    0   2.06 MBytes       
[  7][RX-C]   0.00-1.00   sec  1.08 GBytes  9.31 Gbits/sec                  
[  5][TX-C]   1.00-2.00   sec  1.03 GBytes  8.82 Gbits/sec    0   2.54 MBytes       
[  7][RX-C]   1.00-2.00   sec  1.06 GBytes  9.11 Gbits/sec                  
[  5][TX-C]   2.00-3.00   sec   936 MBytes  7.86 Gbits/sec  211   1.73 MBytes       
[  7][RX-C]   2.00-3.00   sec  1.02 GBytes  8.79 Gbits/sec                  
[  5][TX-C]   3.00-4.00   sec  1.12 GBytes  9.59 Gbits/sec    0   1.94 MBytes       
[  7][RX-C]   3.00-4.00   sec  1024 MBytes  8.58 Gbits/sec                  
[  5][TX-C]   4.00-5.00   sec  1.11 GBytes  9.56 Gbits/sec    0   2.07 MBytes       
[  7][RX-C]   4.00-5.00   sec   952 MBytes  7.99 Gbits/sec                  
[  5][TX-C]   5.00-6.00   sec  1.12 GBytes  9.61 Gbits/sec    0   2.21 MBytes       
[  7][RX-C]   5.00-6.00   sec   971 MBytes  8.15 Gbits/sec                  
[  5][TX-C]   6.00-7.00   sec  1.12 GBytes  9.62 Gbits/sec    0   2.24 MBytes       
[  7][RX-C]   6.00-7.00   sec  1021 MBytes  8.57 Gbits/sec                  
[  5][TX-C]   7.00-8.00   sec  1.11 GBytes  9.57 Gbits/sec    0   2.25 MBytes       
[  7][RX-C]   7.00-8.00   sec  1.10 GBytes  9.47 Gbits/sec                  
[  5][TX-C]   8.00-9.00   sec  1.10 GBytes  9.46 Gbits/sec    0   2.30 MBytes       
[  7][RX-C]   8.00-9.00   sec   977 MBytes  8.19 Gbits/sec                  
[  5][TX-C]   9.00-10.00  sec  1.11 GBytes  9.51 Gbits/sec   62   2.01 MBytes       
[  7][RX-C]   9.00-10.00  sec   980 MBytes  8.22 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-10.00  sec  10.8 GBytes  9.31 Gbits/sec  273             sender
[  5][TX-C]   0.00-10.00  sec  10.8 GBytes  9.30 Gbits/sec                  receiver
[  7][RX-C]   0.00-10.00  sec  10.1 GBytes  8.64 Gbits/sec  168             sender
[  7][RX-C]   0.00-10.00  sec  10.1 GBytes  8.64 Gbits/sec                  receiver
```

#### Performance Between SR-IOV
Interestingly the performance was greater than 10 Gbps when tested between VMs using SR-IOV. I don't know how this is possible, but I'm assuming it's Intel's Virtual Machine Device Queues (VMDq) at work.

##### `iperf3`
```
[  5] local 192.168.0.3 port 37114 connected to 192.168.0.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.77 GBytes  15.2 Gbits/sec    0   3.05 MBytes       
[  5]   1.00-2.00   sec  1.81 GBytes  15.5 Gbits/sec    0   3.05 MBytes       
[  5]   2.00-3.00   sec  1.80 GBytes  15.4 Gbits/sec    0   3.05 MBytes       
[  5]   3.00-4.00   sec  1.80 GBytes  15.5 Gbits/sec    0   3.05 MBytes       
[  5]   4.00-5.00   sec  1.77 GBytes  15.2 Gbits/sec    0   3.05 MBytes       
[  5]   5.00-6.00   sec  1.67 GBytes  14.3 Gbits/sec  172   2.65 MBytes       
[  5]   6.00-7.00   sec  1.62 GBytes  13.9 Gbits/sec    0   2.79 MBytes       
[  5]   7.00-8.00   sec  1.76 GBytes  15.2 Gbits/sec  163   2.62 MBytes       
[  5]   8.00-9.00   sec  1.79 GBytes  15.4 Gbits/sec    0   2.69 MBytes       
[  5]   9.00-10.00  sec  1.79 GBytes  15.4 Gbits/sec    0   2.70 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  17.6 GBytes  15.1 Gbits/sec  335             sender
[  5]   0.00-10.00  sec  17.6 GBytes  15.1 Gbits/sec                  receiver
```

##### `iperf3` bidir
```
[ ID][Role] Interval           Transfer     Bitrate         Retr  Cwnd
[  5][TX-C]   0.00-1.00   sec  1.28 GBytes  11.0 Gbits/sec    0   3.11 MBytes       
[  7][RX-C]   0.00-1.00   sec   417 MBytes  3.50 Gbits/sec                  
[  5][TX-C]   1.00-2.00   sec  1.34 GBytes  11.5 Gbits/sec    0   3.11 MBytes       
[  7][RX-C]   1.00-2.00   sec   457 MBytes  3.83 Gbits/sec                  
[  5][TX-C]   2.00-3.00   sec  1.15 GBytes  9.91 Gbits/sec  177   2.88 MBytes       
[  7][RX-C]   2.00-3.00   sec   459 MBytes  3.85 Gbits/sec                  
[  5][TX-C]   3.00-4.00   sec  1.32 GBytes  11.3 Gbits/sec    0   2.92 MBytes       
[  7][RX-C]   3.00-4.00   sec   413 MBytes  3.46 Gbits/sec                  
[  5][TX-C]   4.00-5.00   sec  1.29 GBytes  11.0 Gbits/sec    0   2.94 MBytes       
[  7][RX-C]   4.00-5.00   sec   525 MBytes  4.40 Gbits/sec                  
[  5][TX-C]   5.00-6.00   sec  1.11 GBytes  9.54 Gbits/sec    0   2.99 MBytes       
[  7][RX-C]   5.00-6.00   sec   692 MBytes  5.80 Gbits/sec                  
[  5][TX-C]   6.00-7.00   sec  1.24 GBytes  10.6 Gbits/sec    0   3.03 MBytes       
[  7][RX-C]   6.00-7.00   sec   577 MBytes  4.84 Gbits/sec                  
[  5][TX-C]   7.00-8.00   sec  1.27 GBytes  10.9 Gbits/sec    0   3.03 MBytes       
[  7][RX-C]   7.00-8.00   sec   518 MBytes  4.34 Gbits/sec                  
[  5][TX-C]   8.00-9.00   sec  1.35 GBytes  11.6 Gbits/sec    0   3.03 MBytes       
[  7][RX-C]   8.00-9.00   sec   444 MBytes  3.73 Gbits/sec                  
[  5][TX-C]   9.00-10.00  sec  1.35 GBytes  11.6 Gbits/sec    0   3.03 MBytes       
[  7][RX-C]   9.00-10.00  sec   454 MBytes  3.81 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-10.00  sec  12.7 GBytes  10.9 Gbits/sec  177             sender
[  5][TX-C]   0.00-10.00  sec  12.7 GBytes  10.9 Gbits/sec                  receiver
[  7][RX-C]   0.00-10.00  sec  4.84 GBytes  4.16 Gbits/sec  157             sender
[  7][RX-C]   0.00-10.00  sec  4.84 GBytes  4.16 Gbits/sec                  receiver
```

#### Comparison

{%- include nic-comparison.html -%}

#### Conclusion
Overall it's probably the best card with fully supported SR-IOV you can get for under US$50.
