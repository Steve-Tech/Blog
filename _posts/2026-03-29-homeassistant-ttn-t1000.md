---
layout: post
title:  "A better way to use The Things Network with Home Assistant (with the SeeedStudio T1000)"
---

The Things Network (TTN) is a popular LoRaWAN network server that allows you to connect your LoRaWAN devices to the internet. However, the official integration with Home Assistant relies on polling the TTN API, which can be slow and unreliable. In this post, I will show you how to use the TTN's MQTT integration with Home Assistant, which is much faster, more reliable, and provides downlink support.

<!--more-->

#### Configuring MQTT

As only a single instance of MQTT can be enabled in Home Assistant, we will have to configure a bridge between the TTN MQTT broker and Home Assistant's MQTT broker. These instructions assume you are using the Mosquitto MQTT broker add-on in Home Assistant, but the general idea should be the same for any MQTT broker.

1. **Find your TTN MQTT broker details**

    You can find these in the TTN console under 'Integrations' -> 'MQTT'. You will need the following details:

    - **Public TLS address**: This is the address of the TTN MQTT broker, e.g. `au1.cloud.thethings.network:8883`. You can ignore the unencrypted 'Public address' option.
    - **Username**: This is the username for the MQTT broker, e.g. `appid@ttn`.
    - **Password**: This is the password for the MQTT broker, which you can generate in the TTN console. Make sure to copy this password somewhere safe, as you won't be able to see it again. This will usually start with `NNSXS.` and be followed by a random string of characters.

2. **Enable custom Mosquitto configurations**

    This should be in the Mosquitto broker settings, and then you go 'Configuration' -> 'Options' -> open 'Customize' -> enable 'active' -> save.

    By default, the 'folder' option is set to `mosquitto`, which means that any additional configuration files need to be placed in the `/share/mosquitto` folder on your Home Assistant instance. However, you may need to create this folder yourself, as it doesn't exist by default; you can do this by opening up a terminal and running `mkdir /share/mosquitto`.

3. **Add the MQTT bridge configuration**

    You can create a new file in the `/share/mosquitto` folder called `ttn.conf`, and add the following configuration to it:

    ```conf
    connection thethingsnetwork
    address au1.cloud.thethings.network:8883
    remote_username appid@ttn
    remote_password NNSXS.VEEBURF3KR77ZR..
    topic # both 0 ttn/ ""
    cleansession true
    bridge_capath /etc/ssl/certs/
    ```

    Make sure to replace `appid@ttn` and `NNSXS.VEEBURF3KR77ZR..` with your actual TTN MQTT username and password. This will now bridge all topics from the TTN MQTT broker to your Home Assistant MQTT broker under the `ttn/` topic prefix.

    Tip: I opened a terminal in the VSCode integration, and used `code /share/mosquitto/ttn.conf` to create and edit the file directly from there.

4. **Restart the MQTT broker**

    You can do this from the Home Assistant UI by going to 'Supervisor' -> 'Mosquitto broker' -> 'Restart'.

#### Configuring Home Assistant

As TTN is not compatible with Home Assistant's auto-discovery, you will need to manually configure the MQTT sensors in Home Assistant to listen for messages from the TTN MQTT broker. You should read the [TTN MQTT documentation](https://www.thethingsindustries.com/docs/integrations/other-integrations/mqtt/) to understand the general structure of the topics and messages.

Here is an example configuration for a SeeedStudio T1000-A device, which includes a device tracker for the location, sensors for temperature and battery level, as well as a button to trigger the buzzer using a downlink message:

{% raw %}

```yaml
mqtt:
  # Example device tracker
  device_tracker:
    - name: "T1000 Location"
      unique_id: t1000_location
      # Replace 'appid' and 't1000' with your actual app ID and device ID from TTN
      state_topic: "ttn/v3/appid@ttn/devices/t1000/up"
      json_attributes_topic: "ttn/v3/appid@ttn/devices/t1000/up"
      json_attributes_template: >
        {% if value_json.uplink_message.decoded_payload.latitude is defined and 
              value_json.uplink_message.decoded_payload.longitude is defined %}
          { 
            "latitude": {{ value_json.uplink_message.decoded_payload.latitude }},
            "longitude": {{ value_json.uplink_message.decoded_payload.longitude }}
          }
        {% else %}
          {# If keys are missing, return an empty object or null to prevent errors #}
          {}
        {% endif %}
      source_type: gps
  # Example sensors
  sensor:
    - name: "T1000 Temperature"
      unique_id: t1000_temperature
      # Replace 'appid' and 't1000' with your actual app ID and device ID from TTN
      state_topic: "ttn/v3/appid@ttn/devices/t1000/up"
      unit_of_measurement: "°C"
      device_class: temperature
      state_class: measurement
      value_template: >
        {% if value_json.uplink_message.decoded_payload.temp1 is defined %}
          {{ value_json.uplink_message.decoded_payload.temp1 }}
        {% endif %}
    - name: "T1000 Battery"
      unique_id: t1000_battery
      # Replace 'appid' and 't1000' with your actual app ID and device ID from TTN
      state_topic: "ttn/v3/appid@ttn/devices/t1000/up"
      unit_of_measurement: "%"
      device_class: battery
      state_class: measurement
      value_template: >
        {% if value_json.uplink_message.decoded_payload.batteryLevel is defined %}
          {{ value_json.uplink_message.decoded_payload.batteryLevel }}
        {% endif %}
  # Example downlink command
  button:
    - name: "T1000 Buzzer"
      unique_id: "t1000_buzzer"
      # Replace 'appid' and 't1000' with your actual app ID and device ID from TTN
      command_topic: "ttn/v3/appid@ttn/devices/t1000/down/push"
      # 0x8201 is ggE= in base64, frm_payload requires base64
      payload_press: >-
        {
          "downlinks": [
            {
              "f_port": 5,
              "frm_payload": "ggE=",
              "priority": "NORMAL"
            }
          ]
        }
```

{% endraw %}

If you are using these examples with a T1000, be sure to use [my custom payload formatter](https://gist.github.com/Steve-Tech/c572309397592f994efe376c046f6f68) from the [previous article](/posts/seeedstudio-t1000-traccar), as the default SeeedStudio payload formatter is not compatible with this configuration.

#### Affiliate Links & Coupons

If you are interested in purchasing from SeeedStudio, you can use the following affiliate links to support my work:

- [SeeedStudio Trackers](https://www.seeedstudio.com/Positioning-Tracker-c-2495.html?sensecap_affiliate=WpDECrz&referring_service=link)
- [Home Assistant Compatible Products](https://www.seeedstudio.com/Home-Assistant-c-2422.html?sensecap_affiliate=WpDECrz&referring_service=link)
- Coupon: `G57NNL2Z` - US$2 off your cart
- Coupon: `N6LV6SY2` - 5% off some Home Assistant products

I run no external ads on this blog, and I spent my own money on my T1000-A, so if you found this guide helpful and are considering purchasing a T1000, please click the affiliate links above. It doesn't cost you anything extra, but it incentivises me to write more guides like this in the future! Alternatively you can also [sponsor me on GitHub](https://github.com/sponsors/Steve-Tech).
