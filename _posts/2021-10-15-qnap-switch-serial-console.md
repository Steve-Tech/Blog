---
layout: post
title:  "Things you can do with a QNAP Switch's Serial Console"
author: Steve-Tech
---

I have a QNAP QSW-M408-4C and I was wondering what the serial console port was used for, especially since it wasn't documented anywhere. Well it turns out it's a full TTY in LEDE Linux. Thanks to [u/sinisterpisces's post](https://www.reddit.com/r/qnap/comments/ofv6ge/qswm21082c_console_port_do_i_need_a_special_usb/) who inspired me to find out more about it.

## Requirements
* You will need a Cisco compatible RJ45 Console Port to Serial/USB adapter
	* [Known working from Amazon](https://www.amazon.com/gp/product/B075V1RGQK/)
	* [Known working from AliExpress](https://www.aliexpress.com/item/1005002029338638.html)

## Connecting via Serial
#### Windows (PuTTY)
* Install [PuTTY](https://www.putty.org/), this is probably also possible to do with PowerShell, but I don't know how.
* In PuTTY, set the 'Connection Type' to "Serial"
* Find the COM port in Device Manager under 'Ports (COM & LPT)'
* Back to PuTTY, set the 'Serial Line' to the COM port you found
* Set the 'Speed' to 115200

#### Linux (Screen)
* Install screen (It's often already installed)
* Run `ls /dev/tty*` to find the Serial Adapter (usually starts with /dev/ttyUSB or /dev/ttyS)
* Run `screen [adapter path] 115200` to connect

#### Logging in
* Press enter then enter the username and password used for the web interface

## Scripts
There's multiple scripts just lying around on the switch that can be used for various things. You can find them all with `find / -name *.sh`.

#### Here's a clean list:
    root@LEDE:/admin# ls /usr/bin/*.sh /bin/*.sh /sbin/*.sh /etc/*.sh
    /bin/ipcalc.sh               /usr/bin/firmware_update.sh
    /etc/diag.sh                 /usr/bin/genenvs.sh
    /etc/reg_boardinfo.sh        /usr/bin/isscli.sh
    /etc/setvlans.sh             /usr/bin/issip.sh
    /etc/start_service.sh        /usr/bin/issnet2tap.sh
    /sbin/fan_ctrl.sh            /usr/bin/isspass.sh
    /sbin/led.sh                 /usr/bin/issswname.sh
    /sbin/prepare_system.sh      /usr/bin/luacli.sh
    /sbin/qsw_fwupgrade.sh       /usr/bin/runisscmd.sh
    /usr/bin/evdisp.sh           /usr/bin/setmode.sh
    /usr/bin/event.sh            /usr/bin/sys_stat.sh

#### Here's a few of the ones I've looked at:
* `sys_stat.sh` Gets/sets fan speeds, temp, rtc, leds, memory, reset, i2c, and mode (`--help` works)
* `isscli.sh` Uses some hidden API on tcp://localhost:6023 (Blocked by iptables)
* `isspass.sh` Sets the UI Password using said API using the MAC Address as the old password
* `reg_boardinfo.sh` Sets MAC, Serial and Model (I think)
* `fan_ctrl.sh` & `led.sh` Self explanatory but doesn't seem to work

## Remote Access
#### Enabling SSH
The switch seems to have SSH enabled by default but it's blocked by `iptables`, here's how to unblock it:
* Type `iptables -L INPUT 2` and you should get `DROP tcp -- anywhere anywhere tcp dpt:ssh`
* If you do type `iptables -D INPUT 2`
* If you don't type `iptables -L INPUT --line-numbers | grep ssh` then `iptables -D INPUT [line number]`
* I don't believe this will unblock it permanently but tell me if it does

#### Enabling the API
The switch uses this API on port 6023 internally but unless you want to create your own management interface on another computer there isn't much point, in fact this is kind of a security hole so don't do it unless you have a good reason:
* Do the same as SSH but grep port 6023, it's line 3 for me.

## Additional Things
#### Installing Packages
To install packages with `opkg`:
* `opkg update`
* `opkg install <package>` I installed htop since it wasn't installed for me

#### Config
There's also some extra VLAN config in `/etc/iss_vlan.txt` that might let you tag VLAN 1.
