---
layout: post
title:  "Most WPA3 WiFi QR Codes are broken"
---

WiFi QR codes have recently become a convenient way to share WiFi credentials, however, many implementations aren't spec-compliant when it comes to WPA3 networks. While most devices only parse the SSID and password, it leaves me with a bad taste in my mouth knowing that the QR code is technically invalid.

<!--more-->

#### How WiFi QR Codes work

Since QR codes are the perfect medium for storing a small amount of text, the WiFi Alliance defines a standard format for encoding WiFi credentials in QR codes. This format was also originally by the [ZXing (Zebra Crossing)](https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11) QR code library, but is now part of the [WPA3 specification](https://www.wi-fi.org/system/files/WPA3%20Specification%20v3.5.pdf). The official format is defined in [section 7.1 of the WPA3 specification](https://www.wi-fi.org/system/files/WPA3%20Specification%20v3.5.pdf#%5B%7B%22num%22%3A108%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C33%2C734%2C0%5D) as follows:

```text
WIFI-qr = “WIFI:” [type “;”] [trdisable “;”] ssid “;” [hidden “;”] [id “;”] [password “;”] [public-
key “;”] “;”
type = “T:” *(unreserved) ; security type
trdisable = “R:” *(HEXDIG) ; Transition Disable value
ssid = “S:” *(printable / pct-encoded) ; SSID of the network
hidden = “H:true” ; when present, indicates a hidden (stealth) SSID is used
id = “I:” *(printable / pct-encoded) ; UTF-8 encoded password identifier, present if the password
has an SAE password identifier
password = “P:” *(printable / pct-encoded) ; password, present for password-based authentication
public-key = “K:” *PKCHAR ; DER of ASN.1 SubjectPublicKeyInfo in compressed form and encoded in
“base64” as per [6], present when the network supports SAE-PK, else absent
printable = %x20-3a / %x3c-7e ; semi-colon excluded
PKCHAR = ALPHA / DIGIT / %x2b / %x2f / %x3d
```

* In this version of the specification, the URI supports provisioning of credentials for Wi-Fi networks using password-based authentication, and for unauthenticated (open and Wi-Fi Enhanced Open™) Wi-Fi networks.
* If the "type" is present, its value is set to "WPA" and it indicates password-based authentication is used.
* If the "type" is absent, it indicates an unauthenticated network (open or Wi-Fi Enhanced Open).
* NOTE: This specification does not define usage of the WIFI URI with WEP shared key.
* The value of "trdisable", if present, is set to a hexadecimal representation of the Transition Disable bitmap field (defined in Section 8).
* NOTE: "trdisable" allows transition modes to be disabled at initial configuration of a Network Profile, and therefore provides protection against downgrade attack on a first connection (e.g., before a Transition Disable indication is received from an AP).
* The values of "ssid", "password", and "id" are, in general, octet strings. Octets that do not correspond to characters in the printable set defined in this ABNF rule are percent-encoded.
* NOTE: The semi-colon is excluded from the printable set as defined in this ABNF rule, and therefore is percent-encoded.
* NOTE: When the password is used with WPA2-Personal (including WPA3-Personal Transition Mode), it comprises only ASCII-encoded characters. When the password is used with only SAE, it comprises octets with arbitrary values. The SAE password identifier is a UTF-8 string.
* Devices parsing this URI shall ignore semicolon separated components that they do not recognize in the WIFI-qr instantiation. Ignoring unknown components allows devices to be forward compatible with future extensions to this specification

##### Transition Disable Values

These are the possible values for the `R:` field:

| Value | Name                        |
|-------|-----------------------------|
| 1     | WPA3-Personal Only (SAE)    |
| 2     | SAE-PK Only                 |
| 4     | WPA3-Enterprise             |
| 8     | Wi-Fi Enhanced Open         |
{: .table }

As this is a bitmap, it is possible to bitwise OR multiple values together. However, I am unsure if that is valid in this context, or how a client would interpret that.

##### The specification then provides a few examples

1. `WIFI:T:WPA;S:MyNet;P:MyPassword;;`
    * STA that supports WPA3-Personal might use SAE or PSK (WPA3-Personal Transition Mode)
    * STA that does not support WPA3-Personal uses PSK (WPA2-Personal)
2. `WIFI:T:WPA;R:1;S:MyNet;P:MyPassword;;`
    * STA that supports WPA3-Personal and Transition Disable uses SAE only (WPA3-Personal Only Mode)
    * STA that supports WPA3-Personal but not Transition Disable might use SAE or PSK (WPA3-Personal Transition Mode)
    * STA that does not support WPA3-Personal uses PSK (WPA2-Personal)
3. `WIFI:T:WPA;R:3;S:MyNet;P:a2bc-de3f-ghi4;K:MDkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDIgADURzxmttZoIRIPWGoQMV00XHWCAQIhXruVWOz0NjlkIA=;;`
    * STA that supports SAE-PK (and, therefore, Transition Disable) uses SAE-PK only (WPA3-Personal SAE-PK Only Mode)
    * STA that supports WPA3-Personal and Transition Disable but not SAE-PK uses SAE without SAE-PK only (WPA3-Personal Only Mode)
    * STA that supports WPA3-Personal but not Transition Disable or SAE-PK might use SAE or PSK (WPA3-Personal Transition Mode)
    * STA that does not support WPA3-Personal uses PSK (WPA2-Personal)
4. `WIFI:S:MyNet;;`
    * STA that supports Wi-Fi Enhanced Open might use Wi-Fi Enhanced Open or legacy open (Wi-Fi Enhanced Open Transition Mode)
    * STA that does not support Wi-Fi Enhanced Open uses legacy open

##### How to generate WiFi QR Codes

I've created a simple client side only web app that generates WPA3-compliant WiFi QR codes:

* [wifi-qr.stevetech.au (Cloudflare Pages)](https://wifi-qr.stevetech.au/)
* [steve-tech.github.io/WiFi-QRCode (GitHub Pages)](https://steve-tech.github.io/WiFi-QRCode/)
* [Source Code (GitHub)](https://github.com/Steve-Tech/WiFi-QRCode)

#### The Common Mistake

The most common issue I've found, is some platforms will use `SAE` as the type. While the spec clearly states 'If the "type" is present, its value is set to "WPA" and it indicates password-based authentication is used'.

The WPA3 specification also states that characters outside of the printable set and semi-colons must be percent-encoded. However, Android does not percent-encode these characters, and escapes semi-colons with a backslash instead. Technically this does follow the [ZXing](https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11) format, but the WPA3 specification clearly states that it must be percent-encoded.
The most annoying part of this issue though, is that Android does also not understand percent-encoding when scanning QR codes.

There are also a few minor issues that seem to affect every platform, such as a network with transition disable (e.g. not WPA2/3, but WPA3 only), will often omit the `R:` field entirely, but this might be due to technical limitations.

Here are some examples of QR codes generated by various platforms:

* Android: `WIFI:S:MyNet;T:SAE;P:MyPassword;H:false;;` (Invalid)
* KDE Plasma: `WIFI:S:MyNet;T:SAE;P:MyPassword;;` (Invalid)
* Gnome: `WIFI:S:MyNet;T:SAE;P:MyPassword;;` (Invalid)
* Windows: `WIFI:T:WPA;S:MyNet;P:MyPassword;;` (Valid)
* iOS/macOS is untested, please comment if you have results.
