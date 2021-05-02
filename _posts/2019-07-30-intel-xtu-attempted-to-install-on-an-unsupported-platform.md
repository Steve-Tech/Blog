---
id: 1200
title: 'Intel XTU ‘Attempted to install on an unsupported platform’'
date: 2019-07-30T19:50:47+10:00
author: Steve-Tech
layout: post
guid: /?p=1200
permalink: /2019/07/30/intel-xtu-attempted-to-install-on-an-unsupported-platform/
categories:
  - Tutorials
---
I was recently wanting to mess around with the CPU clocks on my laptop which is a Surface Book 2 using Intel Extreme Tuning Utility, but whenever I tried to install it I was greeted by an error dialogue that said ‘Attempted to install on an unsupported platform’. This is how I fixed it&#8230;

  1. Download the official [Intel XTU](https://downloadcenter.intel.com/download/24075/Intel-Extreme-Tuning-Utility-Intel-XTU-)
  2. Open it until you get to the error but do not close it
  3. Open File Explorer to ‘C:\ProgramData\Package Cache’ and search for ‘xtu’ look for something named ‘Intel_XtuInstaller.msi’, ‘XTUInstaller.msi’ or something similar
  4. Copy it to a safe place (ie. your Desktop or Documents)
  5. Open CMD to the directory you copied the .msi file to (You can type cmd in the address bar to do this automatically) and type in `msiexec /i Intel_XtuInstaller.msi DISABLEPLATFORMCHECK=1`
  6. You have to restart your laptop otherwise you will get an error along the lines of ‘the drivers are not present’ (trust me I’ve tried)