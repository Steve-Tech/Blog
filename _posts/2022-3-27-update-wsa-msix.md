---
layout: post
title:  "How to update Windows Subsystem for Android from MSIX"
author: Steve-Tech
---

I just happened to realise that the version of Windows Subsystem for Android on [store.rg-adguard.net](https://store.rg-adguard.net/) has updated from 1.7.32815.0 to 2203.40000.1.0 so here's a guide on how to update it without loosing installed apps.

1. Uninstall preserving data

	```powershell
	Remove-AppxPackage -Package "MicrosoftCorporationII.WindowsSubsystemForAndroid_1.7.32815.0_x64__8wekyb3d8bbwe" -PreserveApplicationData
	```
	
	The Package argument should be the same as `(Get-AppxPackage -Name "MicrosoftCorporationII.WindowsSubsystemForAndroid*").PackageFullName`

2. Install new version

	```powershell
	Add-AppxPackage -Path .\MicrosoftCorporationII.WindowsSubsystemForAndroid_2203.40000.1.0_neutral_~_8wekyb3d8bbwe.Msixbundle
	```
	
	The Path argument should be the same as the file downloaded from [store.rg-adguard.net](https://store.rg-adguard.net/)

Done!
