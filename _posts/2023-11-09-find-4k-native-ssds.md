---
layout: post
title:  "Find 4K Native Supported SSDs"
---

I was recently looking for a 4Kn supported SSD for my laptop, I know it doesn't really improve performance by a noticeable amount, I was more just looking for power efficiency, which also hasn't really been benchmarked. So... uhh... higher number better right?<!--more-->

#### Using the [Linux Hardware Database](https://linux-hardware.org/?view=search&typeid=disk&busid=nvme)

- I have found the most luck by entering the model name (not model number) of the SSD, eg. "SN850" for a "Western Digital 1TB Black SN850", and leaving the rest blank.
- Choose whatever result looks most like your SSD, and click on it.
- Then click on whatever probe result you feel like, I prefer to stick to the ones with a 'works' status. It might be best to cross reference multiple results too.
- Now on that probe's page, scroll down to Logs, and click `Smartctl`.
- Under `Supported LBA Sizes`, you should hopefully see (at least) two entries, `512` and `4096`. If you only see `512`, then the SSD does not support 4Kn.
- `Namespace 1 Formatted LBA Size:` Will also tell you the LBA that the SSD is currently formatted to, which is usually the default LBA size (unless the user has changed it).

#### Formatting as 4Kn

**Note: This will destroy any data currently on the drive!**

There is a great article on the [Arch Wiki for formatting as Advanced Format](https://wiki.archlinux.org/title/Advanced_Format#Changing_sector_size), but mostly:

- You would want `nvme-cli` installed,
- Use `nvme id-ns -H /dev/nvme0n1` to double check it supports 4K LBAs (replacing `nvme0n1` with the respective device)
- Then run `nvme format --lbaf=1 /dev/nvme0n1` (replacing '`1`' with the respective LBA ID)

#### Popular 4Kn drives

This was quickly thrown together, so it will not be detailed, complete, accurate, or up to date. I will try to keep it updated though.

|Drive|Max LBA|Default LBA|
|---|---|---|
|Western Digital 1TB Black|4096|512|
|Corsair MP600 CORE XT 1TB|4096|512|
|Crucial T700 1TB|4096|512|
|Kingston FURY Renegade 2TB|4096|512|
|Kingston KC3000 2TB|4096|512|
|Samsung 1TB 990 Pro|512|512|
|Crucial P5 Plus 1TB|512|512|
{: .table }
