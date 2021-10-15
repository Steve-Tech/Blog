---
layout: post
title:  "Install the PiKVM Arduino HID on other Boards"
author: Steve-Tech
---

This is just a short guide to compiling and uploading the PIKVM Arduino HID onto other boards. I will be using the Arduino Leonardo as an example.

## Requirements
* The boards that you are compiling must be supported by [HID-Project](https://github.com/NicoHood/HID) since this is a library that PiKVM uses
* I do not believe that boards using Hoodloader2 firmware are supported

## Wiring
[Follow the official wiring](https://github.com/pikvm/pikvm#setting-up-the-v0)  
Mine is wired like so:  
```
RasPi ->  Arduino
5V    ->  5V
5V    ->  HV
3V3   ->  LV
GND   ->  GND
TX -> TXI -> RX
RX -> RXO -> TX
GND   ->  Pin 1 2N2222
GPIO4 ->  Pin 2 2N2222
Pin 3 2N2222 -> RST
```

## Steps
1. Follow the official steps for the TTL Firmware on [Flashing the Arduino HID](https://github.com/pikvm/pikvm/blob/master/pages/flashing_hid.md) but stop after `cd ~/hid`
2. Find you board for PlatformIO [here](https://docs.platformio.org/en/latest/boards/index.html#boards)
3. Open platformio.ini (You can do this with `nano platformio.ini`)
4. Under `[env]` change the platform and board to match step 2.

	Leonardo example:
	```
	platform = atmelavr
	board = leonardo
	```
5. Save (`Ctrl` + `X`, then `Y`) and contine the official steps.

## Additional Notes
* My Logic Level converter or RPi TTL pins didn't seem to work so a USB to TTL serial adapter was used.