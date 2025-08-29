---
layout: post
title:  "An Efficient Way to Read a Fan's Tachometer Signal with a Raspberry Pi"
---

I use a Raspberry Pi to control a PWM fan in one of my comms racks, and I wanted to monitor the fan's speed using its tachometer signal. This guide will use a kernel module to count the tachometer pulses and present it to telegraf, which can then be visualized in Grafana; as well as some basic PWM fan control. This is more of an advanced guide, you should probably look at the [DriftKingTW](https://blog.driftking.tw/en/2019/11/Using-Raspberry-Pi-to-Control-a-PWM-Fan-and-Monitor-its-Speed/)'s guide if you're unsure what you're doing.

<!--more-->

#### Hardware Setup

On most computer fans, the first 2 pins are for power and ground, the third pin is the tachometer signal, and PWM fans have a fourth pin for speed control. Power and ground can be connected to the Raspberry Pi's 5V and GND pins, or wherever you are powering the fan from. The tachometer pin can be connected to any GPIO pin on the Raspberry Pi, and the PWM pin can be connected to a hardware PWM pin.

I am using a Noctua NF-A12x25-5V-PWM, and it is connected as follows:

| Fan Pin | Raspberry Pi Pin |
|---|---|
| 1 (Power) | 5V |
| 2 (Ground) | GND |
| 3 (Tachometer) | GPIO 23 |
| 4 (PWM) | GPIO 18 |
{: .table }

#### Installing the Kernel Module

Using a kernel module is the most efficient way to read the tachometer signal, as any other way will require a hand off to user space, and I wanted to avoid that overhead even if it's only interrupting ~60 times a second. I will be using [rszimm](https://github.com/rszimm)'s [gpio-counter](https://github.com/rszimm/gpio-counter) module, which will count the pulses and expose the count via a sysfs interface.

1. **Install the required packages**: You will need the kernel headers and build tools to compile the module.

    ```bash
    sudo apt update
    sudo apt install raspberrypi-kernel-headers build-essential
    ```

2. **Clone the gpio-counter repository**

    ```bash
    git clone https://github.com/rszimm/gpio-counter.git
    cd gpio-counter
    ```

3. **Add a DKMS config**: This will allow the module to be automatically rebuilt when the kernel is updated.

    Create a file named `dkms.conf` with the following content:

    ```conf
    PACKAGE_NAME="gpio-counter"
    PACKAGE_VERSION="1.0"
    AUTOINSTALL="yes"

    # Module(s) to build
    BUILT_MODULE_NAME[0]="gpio-counter"

    # Source and build locations
    DEST_MODULE_LOCATION[0]="/extra"
    MAKE[0]="make -C ${kernel_source_dir} M=${dkms_tree}/${PACKAGE_NAME}/${PACKAGE_VERSION}/build"
    CLEAN="make -C ${kernel_source_dir} M=${dkms_tree}/${PACKAGE_NAME}/${PACKAGE_VERSION}/build clean"
    ```

4. **Add the module to DKMS**

    ```bash
    sudo dkms add .
    sudo dkms build gpio-counter/1.0
    sudo dkms install gpio-counter/1.0
    ```

#### Configuring the Kernel Module

1. **Finding your GPIO pin**
    gpio-counter uses kernel GPIO numbering, you can use the following command to list the GPIO pins and their numbers. On my Pi 5 GPIO23 is `594`.

    ```bash
    cat /sys/kernel/debug/gpio
    ```

2. **Load the module**: You can load the module with the following command, replacing `GPIO_PIN` with the GPIO pin number you found in the previous step.

    ```bash
    sudo modprobe gpio-counter gpio=GPIO_PIN
    ```

3. **Check the sysfs interface**: The module will create a sysfs interface at `/sys/kernel/gpio-counter/pulse_count`. You can check the current count with:

    ```bash
    cat /sys/kernel/gpio-counter/pulse_count
    ```

4. **Make the module load on boot**: To ensure the module loads on boot, you can create a file in `/etc/modules-load.d/` and add the module name to it. You should also create a modprobe configuration file to set the GPIO pin.

    ```bash
    echo gpio-counter | sudo tee /etc/modules-load.d/gpio-counter.conf
    echo options gpio-counter gpio_pin=GPIO_PIN | sudo tee /etc/modprobe.d/gpio-counter.conf
    ```

#### Configuring Telegraf

1. **Creating a long running script**: To calculate the fan RPM, I created a simple bash script at `/opt/count_fan_speed.sh`. It will read the pulse count, then wait for a new line from STDIN, then get a second pulse reading, calculate the RPM based on the time interval and pulse count difference, and output it in a format suitable for Telegraf.

    ```bash
    #!/usr/bin/env bash

    SYSFS="/sys/kernel/gpio-counter/pulse_count"
    PPR=2  # Pulses per revolution (usually 2)

    while true; do
      timestamp1=$(date +%s%3N)
      count1=$(<"$SYSFS")
      read -r
      timestamp2=$(date +%s%3N)
      interval_ms=$((timestamp2 - timestamp1))
      count2=$(<"$SYSFS")
      delta=$((count2 - count1))
      # counter wrapped around
      if [ "$delta" -lt 0 ]; then
        delta=0
        continue
      fi
      # RPM = delta * 60000 / (interval_ms * PPR)
      if [ "$interval_ms" -gt 0 ]; then
        rpm=$(( delta * 60000 / (interval_ms * PPR) ))
      else
        rpm=0
      fi

      echo "rack_fan,location=upstairs rpm=$rpm"
    done
    ```

2. **Configuring Telegraf**: Add this snippet to your Telegraf configuration file (usually located at `/etc/telegraf/telegraf.conf`):

    ```toml
    [[inputs.execd]]
    command = ["/opt/count_fan_speed.sh"]
    signal = "STDIN"
    data_format = "influx"
    ```

3. **Configure Grafana**: There are lots of ways to query this data in Grafana, but you will basically need to query the `rack_fan` measurement and use the `rpm` field, and group by the `location` tag if you have multiple fans. Here's a screenshot of my fan speed graph in Grafana:

    ![Grafana Screenshot](/img/articles/raspberry-pi-fan-tacho/grafana-screenshot.png)

#### Basic PWM Fan Control

For PWM fan control, you will need a 4 pin fan, as 3 pin fans do not have a PWM control pin.

I created this basic script at `/opt/fan_control.sh` to control the fan speed, you may need to change the sysfs path for your Pi model and GPIO pin:

```bash
#!/usr/bin/env bash

MIN_TEMP=40000  # 40.000 C
MAX_TEMP=80000  # 80.000 C

INTERVAL=1  # 1 Second interval between checking temperatures

PWM_PERIOD=40000  # 25KHz
TEMP_MUL=$(($PWM_PERIOD / ($MAX_TEMP - $MIN_TEMP)))

echo 2 > /sys/class/pwm/pwmchip0/export  # Export pwm2 to sysfs
echo $PWM_PERIOD > /sys/class/pwm/pwmchip0/pwm2/period  # Set PWM Period
echo $PWM_PERIOD > /sys/class/pwm/pwmchip0/pwm2/duty_cycle  # Set Duty Cycle to max as failsafe
echo 1 > /sys/class/pwm/pwmchip0/pwm2/enable  # Enable PWM

while :; do
    temp=$(< /sys/class/thermal/thermal_zone0/temp)

    if (($temp < $MIN_TEMP)); then
        duty=0
    elif (($temp > $MAX_TEMP)); then
        duty=$PWM_PERIOD
    else
        duty=$((($temp - $MIN_TEMP) * $TEMP_MUL))
    fi

    echo $duty
    echo $duty > /sys/class/pwm/pwmchip0/pwm2/duty_cycle

    sleep $INTERVAL
done
```

I also created a systemd service at `/lib/systemd/system/fan_control.service` to run this script on boot:

```ini
[Unit]
Description=PWM Fan Control

[Service]
Type=simple
TimeoutStartSec=0
Restart=on-failure
RestartSec=30s
ExecStart=/opt/fan_control.sh

[Install]
WantedBy=multi-user.target
```

You can also add the duty cycle percent to telegraf script that I created at `/opt/count_fan_speed.sh`:

```sh
#!/usr/bin/env bash
SYSFS="/sys/kernel/gpio-counter/pulse_count"
PPR=2  # Pulses per revolution (usually 2)

SYSFS_PERIOD="/sys/class/pwm/pwmchip0/pwm2/period"
SYSFS_DUTY="/sys/class/pwm/pwmchip0/pwm2/duty_cycle"

while true; do
  timestamp1=$(date +%s%3N)
  count1=$(<"$SYSFS")
  read -r
  timestamp2=$(date +%s%3N)
  interval_ms=$((timestamp2 - timestamp1))
  count2=$(<"$SYSFS")
  delta=$((count2 - count1))
  # counter wrapped around
  if [ "$delta" -lt 0 ]; then
    delta=0
    continue
  fi
  # RPM = delta * 60000 / (interval_ms * PPR)
  if [ "$interval_ms" -gt 0 ]; then
    rpm=$(( delta * 60000 / (interval_ms * PPR) ))
  else
    rpm=0
  fi

  period=$(<"$SYSFS_PERIOD")
  duty=$(<"$SYSFS_DUTY")
  percent=$(( duty*100 / period ))

  echo "rack_fan,location=upstairs rpm=$rpm,duty=$percent"
done
```

#### Other Resources

* [DriftKingTW](https://blog.driftking.tw/en/2019/11/Using-Raspberry-Pi-to-Control-a-PWM-Fan-and-Monitor-its-Speed/) has written a much better guide with pictures, however they are using RPi.GPIO for everything, instead of handling stuff in kernel.
* The Noctua PWM white paper is a really good read if you want to understand how PWM fans work: [Noctua PWM White Paper](https://noctua.at/pub/media/wysiwyg/Noctua_PWM_specifications_white_paper.pdf).
