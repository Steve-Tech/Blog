---
layout: post
title:  "Force Enable VRR using EDID"
---

My Samsung LC24RG50 supports FreeSync, but it wouldn't play nice with my Intel ARC GPU, so I ended up force enabling it in the EDID.<!--more-->

#### Modifying the EDID

After a bunch of troubleshooting, I did end up making my monitor present a VRR EDID, which I dumped [here](/downloads/Samsung_LC24RG50_VRR.bin), but here's the things you should modify if you can't:

1. Acquire your monitor's EDID, I used `get-edid > monitor.bin`
2. Using wxEDID, view the EDID's MRL section
3. Set `extd_timg` to `0x01`, I believe this is required for VRR
4. Make sure `min_Vfreq` and `max_Vfreq` are correctly set to your monitor's range (eg. 48-144 Hz)
5. I'm not sure but I think `min_Hfreq` should be the same as `max_Hfreq`, if it's not set it to the same as `max_Hfreq` (eg. Both 168 kHz)

#### Applying the EDID (on Wayland)

1. Copy the EDID to `/usr/lib/firmware/edid/`
2. Add `drm.edid_firmware=DP-1:edid/monitor.bin` to your kernel command line, replacing `DP-1` with your monitor's connector name, and `monitor.bin` with the EDID file name.
3. You may need to create an initramfs hook script, I used [this one](https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/1814938/comments/5).
4. Reboot

##### Multiple EDIDs

You can specify multiple EDIDs in the kernel command line using a comma, eg. `drm.edid_firmware=DP-1:edid/monitor1.bin,DP-2:edid/monitor2.bin`
