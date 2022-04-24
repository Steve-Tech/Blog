---
layout: post
title:  "Install the PiKVM Arduino HID on other Boards"
---

This is just a short guide to compiling and uploading the PIKVM Arduino HID onto other boards. I will be using the Arduino Leonardo as an example.

#### Requirements
* The boards that you are compiling must be supported by [HID-Project](https://github.com/NicoHood/HID) since this is a library that PiKVM uses
* I do not believe that boards using Hoodloader2 firmware are supported

#### Wiring & Setup
[Follow the official wiring and setup](https://docs.pikvm.org/arduino_hid/#usb-keyboard-and-mouse)  
Mine is wired like so:  
```
RasPi ->  Arduino
5V    ->  5V
5V    ->  HV
3V3   ->  LV
GND   ->  GND
TX -> TXI | TXO -> RX
RX -> RXO | RXI -> TX
GND   ->  Pin 1 2N2222
GPIO4 ->  Pin 2 2N2222
Pin 3 2N2222 -> RST
```

#### Steps
1. Follow the official steps for the TTL Firmware on [Flashing the Arduino HID](https://docs.pikvm.org/flashing_hid/#ttl-firmware-the-default-option) but stop after `cd ~/hid`
2. Find your board for PlatformIO [here](https://docs.platformio.org/en/latest/boards/index.html#boards)
3. Open platformio.ini (You can do this with `nano platformio.ini`)
4. Under `[env]` change the platform and board to match step 2.

	Leonardo example:
	```
	platform = atmelavr
	board = leonardo
	```
5. Save (`Ctrl` + `X`, then `Y`) and contine the official steps.

#### Additional Notes
* A USB to TTL serial adapter can be used temporarily instead of the RasPi pins if you don't have a Logic level shifter; you can use another Arduino (Uno works) as a USB to TTL adapter by connecting the RST pin to GND.