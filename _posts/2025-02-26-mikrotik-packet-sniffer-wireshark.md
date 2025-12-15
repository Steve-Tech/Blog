---
layout: post
title:  "The Best Way to Stream MikroTik's Packet Sniffer to Wireshark"
---

While you can use `udp.dstport == 37008` to filter for MikroTik's packet sniffer, I prefer to setup the 'UDP Listener remote capture: udpdump' feature in Wireshark. This way you will have a clean packet capture without having to filter out unrelated traffic, with the benefit of also not spamming your router with ICMP 'Destination Unreachable' packets.
<!--more-->

#### Requirements

Now there is a reason why this isn't often recommended, and that's because it requires the UDPdump component, which isn't selected by default when you install Wireshark on Windows. So you may need to reinstall Wireshark and select the 'UDPdump' component in the installer.

![Wireshark Windows Installer Components](/img/articles/mikrotik-packet-sniffer-wireshark/wireshark-windows-installer.png){: .rounded-3 }

On Debian it's included in the `wireshark-common` package, which should be installed automatically. I'd assume other distributions would be similar.

#### MikroTik Packet Sniffer Configuration

In the Mikrotik Packet Sniffer you need to enable streaming and set the server to your Wireshark machine's IP address. You may also want to set a filter in the filter tab to limit the traffic being captured.

#### Setup

1. In the 'Capture' menu, click the little gear icon next to "UDP Listener remote capture: udpdump".

    ![Wireshark UDPdump Config Icon](/img/articles/mikrotik-packet-sniffer-wireshark/udpdump-config-icon.png){: .rounded }
2. A new window will open, enter your configured listen port (default is `37008`) and enter `tzsp` as the payload type.

    ![Wireshark UDPdump Config Window](/img/articles/mikrotik-packet-sniffer-wireshark/udpdump-config-tzsp.png){: .rounded-1 }
3. Click 'Save' and then 'Start' to begin capturing packets.

    ![Wireshark UDPdump Start Button](/img/articles/mikrotik-packet-sniffer-wireshark/wireguard-packets.png){: .rounded-1 }
