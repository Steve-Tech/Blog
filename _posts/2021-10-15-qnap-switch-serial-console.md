---
layout: post
title:  "Things you can do with a QNAP Switch's Serial Console"
author: Steve-Tech
---

I have a QNAP QSW-M408-4C and I was wondering what the serial console port was used for, especially since it wasn't documented anywhere. Well it turns out it's a full TTY terminal in LEDE Linux. Thanks to [u/sinisterpisces's post](https://www.reddit.com/r/qnap/comments/ofv6ge/qswm21082c_console_port_do_i_need_a_special_usb/) who inspired me to find out more about it.

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

#### Logging in/out
* Press enter then enter the same username and password used for the web interface
* When logging out type `exit` to quit the session

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
* `isscli.sh` "Aricent Intelligent Switch Solution" CLI (also on `tcp://localhost:6023`, blocked externally by iptables)
* `runisscmd.sh` Runs piped input as a command on the CLI (eg. `echo "help" | runisscmd.sh`)
* `luacli.sh` "LUA CLI shell", (`?` for help, some things cause switch to crash)
* `isspass.sh` Sets the UI Password using said API using the MAC Address as the old password
* `reg_boardinfo.sh` Sets MAC, Serial and Model (I think)
* `fan_ctrl.sh` & `led.sh` Self explanatory but doesn't seem to work

## Remote Access
#### Enabling SSH
The switch seems to have SSH enabled by default but it's blocked by `iptables`, here's how to unblock it:

#### Enable SSH until reboot
* Type `iptables -L INPUT 2` and you should get `DROP tcp -- anywhere anywhere tcp dpt:ssh`
* If you do type `iptables -D INPUT 2`
* If you don't type `iptables -L INPUT --line-numbers | grep ssh` then `iptables -D INPUT [line number]`

#### Enable SSH permanently
* Edit `/etc/firewall.user`
	* eg. `vi /etc/firewall.user`
* Add a `#` to the beginning of the line that says `iptables -A INPUT -i cpsstap -p tcp --dport 22 -j DROP` (likely line 2)
	* press `i` to insert in vi
* Save and reboot
	* `ESC` + `:wq` to save in vi
	* `reboot` to reboot in linux

#### Enabling the Aricent CLI
You could do the same to enable the "Aricent Intelligent Switch Solution" CLI on port 6023, but it has a built in username and password on the "debug" user (security issue), and it's already accessible through SSH (especially with `isscli.sh`), so there isn't much point:
* Do the same as SSH but grep port 6023, it's line 3 for me.

## Upgrading Firmware
* Download the firmware from the QNAP site onto the switch: `wget <url>`
* Extract the firmware: `tar -xvf <file name>.img`
* Run `./firmware_update.sh`

You might think `qsw_fwupgrade.sh` from above would do something, it doesn't.

## Additional Things
#### Installing Packages
To install packages with `opkg`:
* `opkg update`
* `opkg install <package>` I installed htop since it wasn't installed for me

#### Config
There's also some extra VLAN config in `/etc/iss_vlan.txt` that might let you tag VLAN 1.
