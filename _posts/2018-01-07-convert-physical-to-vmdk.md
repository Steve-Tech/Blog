---
layout: post
title: How to convert a Physical Disk to a VMware VMDK image
date: 2018-01-07T09:04:48+10:00
---
I was recently wanting to convert all of my old hard drives from old computers to VMDKs so that I could run the drive virtually in VMware, but I couldn’t find a way to do it so that’s why I’m writing this now.<!--more--> Most other guides would use Disk2vhd and use Hyper-V but most people don’t have a pro version of Windows to use that or some guides would say to use VMware vCenter Converter but the physical machine has to be running and I only have the hard drive so I can’t use that. Then I found StarWind V2V Converter which can convert a VHD (and VHDX) file from Disk2vhd and that’s what this guide is going to use.

* * *

#### Stuff to get beforehand

  * Download <a href="https://docs.microsoft.com/en-us/sysinternals/downloads/disk2vhd" target="_blank" rel="noopener noreferrer">Disk2vhd</a> and <a href="https://www.starwindsoftware.com/converter" target="_blank" rel="noopener noreferrer">StarWind V2V Converter</a> (or click this <a href="https://www.starwindsoftware.com/tmplink/starwindconverter.exe" rel="noopener">link to download StarWind V2V Converter</a> without giving your info away).
  * Buy a SATA (or IDE) to USB adapter to easily connect the old hard drive to your computer.

* * *

#### Steps

##### UPDATE

**(12/05/2018):** I’ve recently found [Vmdk2Phys](https://sourceforge.net/projects/vmdk2phys/) which is still in beta (and doesn’t look the best) but is more straightforward then following the guide below. [Vmdk2Phys](https://sourceforge.net/projects/vmdk2phys/) also supports converting VMDKs to physical drives.

  1. Open Disk2vhd and untick all volumes except the one you want to virtualize and pick a location to output the file to, then click the ‘Create’ button. It will take a while to finish depending on the size and speed of your drive.<img src="{% link /assets/img/articles/convert-physical-to-vmdk/Disk2vhd.png %}" alt="Disk2vhd" width="511" height="355" />
  2. Once Disk2vhd finishes open StarWind V2V Converter select ‘Local file’ and click ‘Next >’ when it asks for the ‘Source image location’<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-Image-location.png %}" alt="StarWind V2V Converter - Image location" width="565" height="478" />
  3. Select the ‘Source image’ then click ‘Next >’<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-Source-image.png %}" alt="StarWind V2V Converter - Source image" width="565" height="478" />
  4. Select the format you want to convert to (the 1st and 3rd option are probably the most compatible option with VMware Workstation Player)<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-Destination-image-format.png %}" alt="StarWind V2V Converter - Destination image format" width="565" height="478" />
  5. Select the ‘Virtual disk type’ (Select the one most compatible with the windows installation eg. IDE for Windows XP)<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-VMDK-Options.png %}" alt="StarWind V2V Converter - VMDK Options" width="565" height="478" />
  6. Set your destination file location then click ‘Next >’<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-Destination-file.png %}" alt="StarWind V2V Converter - Destination file" width="565" height="478" />
  7. Run the converted file in VMware Workstation Player<img src="{% link /assets/img/articles/convert-physical-to-vmdk/StarWind-V2V-Converter-Converting-Finished.png %}" alt="StarWind V2V Converter - Converting Finished" width="565" height="478" />