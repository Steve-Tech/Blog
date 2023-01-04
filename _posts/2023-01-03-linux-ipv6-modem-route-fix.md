---
layout: post
title:  "Fix Bad IPv6 Routing from an ISP Modem on Linux"
---
Linux on my PC has always struggled to use IPv6 when connected to my Telstra Smart Modem (Windows was fine however), and it's always bugged me but I could never figure out why, I've tried different distros, NICs, and for some reason I never thought that my ISP would misconfigure my modem so that it would send bad routes over DHCP until now, but here I am. This was tested on Ubuntu, but should work on any distro with NetworkManager.
<!--more-->

#### Symptoms

- [ipv6-test.com](http://ipv6-test.com) will either fail, say something similar to "Danger! IPv6 sorta works - however, large packets appear to fail, giving the appearance of a broken website. If a publisher publishes to IPv6, you will believe their web site to be broken. Ask your ISP about MTU issues; possibly with your tunnel. Check your firewall to make sure that ICMPv6 messages are allowed (in particular, Type 2 or Packet Too Big).", or it just passes.
- Pinging an IPv6 site, eg. `ping -6 one.one.one.one` will sometimes work and sometimes not, basically randomly.
- Some websites will load slower than usual.
- VMs might believe they have IPv6, but fail to load sites half the time.

#### Requirements

You must have 2 or more routes, you can check with `ip -6 r` or `nmcli`:

```sh
$ ip -6 r
::1 dev lo proto kernel metric 256 pref medium
2001:db8:feed:f00::/64 dev ens16 proto ra metric 100 pref medium
2001:db8:feed:f00::/56 via fe80::coo1:cafe dev ens16 proto ra metric 100 pref medium
fe80::/64 dev ens16 proto kernel metric 1024 pref medium
default proto ra metric 100 pref medium
 nexthop via fe80::coo1:cafe dev ens16 weight 1 
 nexthop via fe80::dead:beef dev ens16 weight 1
```

In my case the first one was pingable (it's also the one with the /56 route), the second was not, so the first one would be the most likely to be the actual default route, which it was in my case.

#### Solution

1. Run `nmcli connection` to find the connection ID that you need to modify, if you have multiple that are using the same modem, you will need to repeat the solution for all of them. Replace `<id>` in the next few commands with the connection ID, if it contains spaces then surround them with quotes eg, `"Wired connection 1"`.
2. Run `nmcli connection modify <id> ipv6.ignore-auto-routes yes` This will make the connection ignore IPv6 routes given from DHCP.
3. Run `nmcli connection modify <id> ipv6.routes "::/0 <gateway>"` Replacing <gateway> with the route you want to use, in my example it was `fe80::coo1:cafe`
4. Optionally run `nmcli connection modify <id> +ipv6.routes "<subnet>"` so your local subnet doesn't get routed though your modem, Linux does seem to work it out itself though. (subnet example: `2001:db8:feed:f00::/64`).

#### Finished

You might need to restart your connection (`systemctl restart NetworkManager`), but once `ip -6 r` only shows 1 route, make sure none of the symptoms are still showing; eg. Run [ipv6-test.com](http://ipv6-test.com) a few times until you're comfortable that it's fixed.

For reference this is the working routes for the example:

```sh
$ ip -6 r
::1 dev lo proto kernel metric 256 pref medium
2001:db8:feed:f00::/64 dev ens16 proto static metric 100 pref medium
fe80::/64 dev ens16 proto kernel metric 1024 pref medium
default via fe80::coo1:cafe dev ens16 proto static metric 100 pref medium
```
