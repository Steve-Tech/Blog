---
layout: post
title:  "My Attempt at Precision Time Protocol on Debian"
---

There's a wonderful guide on [Austin's Nerdy Things](https://austinsnerdythings.com/2025/02/18/nanosecond-accurate-ptp-server-grandmaster-and-client-tutorial-for-raspberry-pi/) about setting up PTP, which I encourage you read first! However, the debian package contains it's own systemd services, as well as linuxptp's 'timemaster' for syncing with chrony, so I've simplified *some* of the configuration; but this is more a things I've done than a full tutorial.

<!--more-->

#### Preparation

1. Check if your network interface supports hardware timestamping:

    ```bash
    sudo ethtool -T eth0
    ```

    Look for `hardware-transmit` and `hardware-receive` in the output, if it's missing, then your NIC does not support hardware timestamping, and you will have to use software timestamping instead.

2. Install the `linuxptp` package:

    ```bash
    sudo apt install linuxptp
    ```

#### Server Configuration

1. Edit `/etc/linuxptp/ptp4l.conf` and edit the following options:

    - `domainNumber`: Set this to the same value on all PTP devices, default is `0`.
    - `clockClass`: Set this to `6` if you have a primary reference time source (e.g. GPS), otherwise set it to `248` (default). Other settings are defined in IEEE 1588-2019 - Section 7.6.2.5.
    - `clockAccuracy`: Set this to the appropriate value from IEEE 1588-2019 - Section 7.6.2.6, if you don't know, leave it as `0xFE` (default/unknown).
    - `masterOnly` or `serverOnly`: Set this to `1` to disable the NIC from becoming a slave.
    - `network_transport`: Select between `L2` (Layer 2), `UDPv4`, or `UDPv6`, default is `UDPv4`. This must be the same on all PTP devices. Devices with network bridges may require `L2` (e.g. Proxmox).
    - `time_stamping`: Set this to `hardware` if your NIC supports hardware timestamping, otherwise set it to `software`.
    - `timeSource`: Set this to `0x20` if you are using GPS as your primary reference time source, otherwise use an appropriate value from IEEE 1588-2019 - Section 7.6.2.8, if you don't know, leave it as `0xA0` (default/internal oscillator).

    You may also set `priority1` and `priority2` if you intend on having multiple masters on the same domain, with failure over (lowest first, similar to routing metrics).

    If you can't acquire a copy of the IEEE 1588 standard, you can find similar tables on the [H3C switch documentation](https://www.h3c.com/en/d_202212/1747860_294551_0.htm#_Toc121487972).

2. Edit or copy `/lib/systemd/system/phc2sys@.service`:

    - Remove/comment out the `Requires=` and `After=` lines, as `ptp4l` will depend on `phc2sys` for time instead of the other way around.
    - Change the `ExecStart=` line to:

        ```ini
        ExecStart=/usr/sbin/phc2sys -s CLOCK_REALTIME -c %I -O 37
        ```

        This will sync the system clock to the PTP Hardware Clock (PHC). I was also required to specify the TIA offset of 37 seconds, this will need updating every leap second.

3. Enable and start the `ptp4l` and `phc2sys` services:

    ```bash
    sudo systemctl enable --now ptp4l@eth0 phc2sys@eth0
    ```

    Replace `eth0` with your network interface.

You can use [`check_clocks.c`](https://github.com/Avnu/tsn-doc/blob/master/misc/check_clocks.c) from the [Linux TSN Documentation](https://tsn.readthedocs.io/timesync.html#checking-clocks-synchronization) to check that the PHC and system clock are in sync.

#### Client Chrony/Timemaster Configuration

1. Disable chrony, as timemaster will start it's own chrony instance.

    ```bash
    sudo systemctl disable --now chrony
    ```

2. Edit `/etc/linuxptp/timemaster.conf` and edit the following options:

    ```ini
    # This should match the domainNumber in the server's ptp4l.conf
    [ptp_domain 0]
    # Set this this to your network interface for PTP
    interfaces ens6f0
    # timemaster will add these options to the chronyd PTP0 time source
    ntp_options prefer stratum 1

    [ptp4l.conf]
    # Specify custom ptp4l.conf options here, or leave blank for defaults
    network_transport L2
    ```

3. Enable and start the `timemaster` service:

    ```bash
    sudo systemctl enable --now timemaster
    ```

    You may also want to check the status to ensure it's working correctly:

    ```bash
    sudo systemctl status timemaster
    ```

4. Check the time is correctly being synced:

    ```bash
    chronyc sources -v
    ```

    If you have a GUI you can also use [My_Time](https://mytime.stevetech.au/) or [time.is](https://time.is/) to check the time is actually correct.

#### Client Configuration (Without Chrony/Timemaster)

1. Edit `/etc/linuxptp/ptp4l.conf` and edit the following options:

    - `clientOnly` or `slaveOnly`: Set this to `1` to disable the NIC from becoming a master.
    - `domainNumber`: Set this to the same value on all PTP devices, default is `0`.
    - `network_transport`: Select between `L2` (Layer 2), `UDPv4`, or `UDPv6`, default is `UDPv4`. This must be the same on all PTP devices. Devices with network bridges may require `L2` (e.g. Proxmox).
    - `time_stamping`: Set this to `hardware` if your NIC supports hardware timestamping, otherwise set it to `software`.

2. Edit or copy `/lib/systemd/system/phc2sys@.service`:

    - Add `@` to the `Requires=` and `After=` lines, otherwise it will fail to start.

        ```ini
        Requires=ptp4l@.service
        After=ptp4l@.service
        ```

3. Enable and start the `ptp4l` and `phc2sys` services:

    ```bash
    sudo systemctl enable --now ptp4l@enp12s0f0 phc2sys@enp12s0f0
    ```

    Replace `enp12s0f0` with your network interface.

#### Troubleshooting

- If you get `phc2sys: interface enp12s0f0 does not have a PHC` on boot up, but phc2sys otherwise works fine, you can edit the service (e.g `sudo systemctl edit phc2sys@enp12s0f0.service`) and add the following lines to retry starting:

    ```ini
    [Service]
    Restart=on-failure
    RestartSec=5
    ```

- If you are using this on a desktop and get `clockcheck: clock frequency changed unexpectedly!` after resuming from sleep, you can disable the clockcheck by adding `sanity_freq_limit 0` to `/etc/ptp4l.conf`, and editing the `ExecStart=` line in `phc2sys@.service` to include the `-L 0` option:

    ```ini
    ExecStart=/usr/sbin/phc2sys -w -s %I -L 0
    ```

    If you are using `systemctl edit` to override the service, add an extra `ExecStart=` line before this to clear the previous one.

- On Raspberry Pi 5s you may need to set `hwts_filter full` in `ptp4l.conf` for hardware timestamping to work correctly.
- Hardware timestamping is broken on kernels 6.12.25 to 6.12.35, you will need to upgrade your kernel or use software timestamping instead. As of writing, Raspberry Pi OS is on 6.12.34 (issue: [raspberrypi/linux#6912](https://github.com/raspberrypi/linux/issues/6912)), but you can run `sudo rpi-update` to upgrade to Raspberry Pi's latest pre-release kernel.
- If your machine has network bridges configured on the PTP interface (e.g. Proxmox), you will likely need to use `network_transport L2` in `ptp4l.conf` instead of the default `UDPv4` (This has to be set on all PTP devices).

#### Networking Equipment

There's a bit of confusion about whether or not network switches need to support PTP for it to work. From my understanding, as long as the switch is not configured to interfere with PTP messages, time synchronisation should still work fine; but hardware timestamping may be unreliable, and you might not get peer delay messages.

Some managed switches will allow for hardware timestamping to be updated on the switch itself, and peer delay messages to be sent, which should also improve accuracy.

While using L2, if you want to disable PTP messages being forwarded on PTP-unaware equipment, set `ptp_dst_mac 01:80:C2:00:00:0E` in `ptp4l.conf`, (or alternatively you can set `p2p_dst_mac 01:1B:19:00:00:00` to allow peer delay messages through PTP-unaware equipment, but this is not recommended).

##### MikroTik

Some MikroTik equipment supports PTP configuration, which allows it to act as a boundary clock, and send new hardware timestamps. You can read more on the [MikroTik Wiki](https://help.mikrotik.com/docs/spaces/ROS/pages/64127015/Precision+Time+Protocol).

My CRS312-4C+8XG will still pass PTP messages unmodified with PTP disabled; however accuracy should be improved with PTP enabled as it is now PTP-aware.

#### References

- [Austin's Nerdy Things - Nanosecond accurate PTP server (grandmaster) and client tutorial for Raspberry Pi](https://austinsnerdythings.com/2025/02/18/nanosecond-accurate-ptp-server-grandmaster-and-client-tutorial-for-raspberry-pi/)
- [Linux PTP Project Documentation](https://linuxptp.nwtime.org/documentation/)
- [Linux TSN Documentation - Time Synchronization](https://tsn.readthedocs.io/timesync.html)
- [Timestamping - The Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/networking/timestamping.html)
- [1588-2008 - IEEE Standard for a Precision Clock Synchronization Protocol for Networked Measurement and Control Systems](https://ieeexplore.ieee.org/document/4579760) ([doi.org/10.1109/IEEESTD.2008.4579760](https://doi.org/10.1109/IEEESTD.2008.4579760))
- [1588-2019 - IEEE Standard for a Precision Clock Synchronization Protocol for Networked Measurement and Control Systems](https://ieeexplore.ieee.org/document/9120376) ([doi.org/10.1109/IEEESTD.2020.9120376](https://doi.org/10.1109/IEEESTD.2020.9120376))

I acquired a copy of the IEEE 1588 standards from my university, but you may be able to access them through a library or online paper/journal repository.

Let me know if you have any questions, corrections, or suggestions!
