---
layout: post
title:  "Reverse Engineering CyberPower's RMCARD205 Serial and ENVIROSENSOR"
---

The CyberPower RMCARD205 is a network management card for uninterruptible power supplies (UPS). It has a 'Universal' port that can be used to interface with the RMCARD205 using an RS232 serial connection, or connect an ENVIROSENSOR to monitor temperature and humidity.

<!--more-->

#### RMCARD205 Universal Port Pinout

CyberPower's documentation says it should contain a 'RJ45/DB9 Serial Port Connection Cable', however mine did not. After probing the ENVIROSENSOR with an oscilloscope, I was able to determine the pinout of the Universal port is as follows:

*[N/C]: Not Connected

| Pin | T-568A      | T-568B        | Signal                | DB9 Adapter |
| --- | ----------- | ------------- | --------------------- | ----------- |
| 1   | White/Green | White/Orange  | N/C                   |             |
| 2   | Green       | Orange        | GND                   | 5 (Green)   |
| 3   | White/Orange| White/Green   | N/C                   |             |
| 4   | Blue        | Blue          | 10V VCC (Sensor Only) |             |
| 5   | White/Blue  | White/Blue    | N/C                   |             |
| 6   | Orange      | Green         | RXD (from RMCARD205)  | 3 (Black)   |
| 7   | White/Brown | White/Brown   | N/C                   |             |
| 8   | Brown       | Brown         | TXD (to RMCARD205)    | 2 (Orange)  |
{: .table .t568-table }

**This is not the same as Cisco's RJ45 console pinout. Do not use a standard console cable.**

You can easily create your own adapter using a modular DB9 to RJ45 adapter (such as this one from [StarTech [GC98MF]](https://www.startech.com/cables/gc98mf), or [Jaycar [PA0906]](https://www.jaycar.com.au/p/PA0906) for Australia)

#### RMCARD205 Serial Settings

As the documentation states, the RS232 serial settings are:

- Bits per second: `9600`
- Data bits: `8`
- Parity: `None`
- Stop bits: `1`
- Flow control: `None`

The ENVIROSENSOR uses the same settings.

#### ENVIROSENSOR Communication

The ENVIROSENSOR communicates using simple ASCII commands over the serial connection. Here is the communication flow:

1. **Pre-communication:** *(Optional)*

    This seems to be optional, but the ENVIROSENSOR holds TX high/positive (a RS232 break condition) for 200ms, during which time, the UPS will respond with `#QFM,\xB3\r`.

2. **Setup:**

    The ENVIROSENSOR sends the following command, as if logging in: `@CPS_EnvMo\r`

    This is echoed back by the UPS: `@CPS_EnvMo` (note the lack of a carriage return).

3. **Identify:**

    The UPS requests identification with: `P\r`.

    The ENVIROSENSOR responds with: `#ENVIROSENSOR,1.00,1.00\r`

4. **Query:**

    The UPS requests data with: `Q\r`, usually twice 160ms apart, I believe this is once to take a measurement, and another to read the measurement.

    The ENVIROSENSOR responds with temperature and humidity data in the following format: `#T000.0H000S0000\r`

    Where:

    - `T000.0` is the temperature in Celsius.
    - `H000` is the humidity percentage.
    - `S0000` is the dry contact status (0 for open, 1 for closed).

    e.g. `#T030.1H056S1000` indicates a temperature of 30.1°C, humidity of 56%, and dry contact 1 is closed while the others are open.

    This query is repeated every 5 seconds.

I have oscillograms and logic captures of this communication available upon request, contact me or leave a comment with your email if you would like a copy.

#### Simulating an ENVIROSENSOR

Using the above information, I was able to create a simple Python script to simulate an ENVIROSENSOR when connected to a CyberPower RMCARD205:

```python
#!/usr/bin/env python3
import serial
from time import sleep

ser = serial.Serial('/dev/ttyACM1', baudrate=9600, timeout=1)

temperature = 28.5
humidity = 42
contacts = [False, False, False, False]

# ser.send_break(duration=0.2)
# sleep(2)
# ser.reset_input_buffer()

# Setup
login = '@CPS_EnvMo'
ser.write(login.encode() + b'\r')
ser.read(len(login))

measurement = None

while True:
    if ser.in_waiting:
        line = ser.read_until(b'\r').decode().strip()
        match line:
            case 'P':
                # Identify
                ser.write(b'#ENVIROSENSOR,1.00,1.00\r')
                measurement = None
            case 'Q':
                if not measurement:
                    # You've got 160ms to take your measurement
                    measurement = f'#T{temperature:05.1f}H{humidity:03d}S{"".join("1" if c else "0" for c in contacts)}\r'
                    print(f"Preparing measurement: {measurement[:-1]}")
                else:
                    # Measurement done, send data
                    ser.write(measurement.encode())
                    measurement = None
            case _:
                measurement = None
        print(f"Received: {line}")

```

#### Reading from the ENVIROSENSOR

The ENVIROSENSOR has 2 chips I can easily identify: A [L5973D](https://www.st.com/en/power-management/l5973d.html) voltage regulator, and a [RS21EI](https://www.ti.com/lit/ds/symlink/trs3221e.pdf) RS232 driver. The voltage regulator allows an input voltage of 4-36V, which is provided on pin 4 of the data port; 12v and 5v seemed to work fine.

To simulate a UPS and read an ENVIROSENSOR, all you have to do is wait ~2.5s for the `@CPS_EnvMo` login after the ENVIROSENSOR was given power, then to read the sensors, send `Q\r` twice, 160ms apart.

```python
#!/usr/bin/env python3
import serial
from time import sleep

ser = serial.Serial('/dev/ttyACM1', baudrate=9600, timeout=1)

# Wait for login prompt
# This is only required if the device was just powered on
# sleep(2.5)
# print(ser.read_all().decode().strip())

while True:
    ser.reset_input_buffer()
    ser.write(b'Q\r')
    sleep(0.16)
    ser.write(b'Q\r')
    print(ser.read_until(b'\r').decode().strip())
    sleep(5)

```
