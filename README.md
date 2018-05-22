# pi-iot-sense
Wifi and Bluetooth sensing as an IOT device

<b>SD Card Setup</b>
1. Download the Raspbian Lite Stretch zip file from https://downloads.raspberrypi.org/raspbian_lite_latest
2. Using a product such as Etcher (mac), burn the Rasbian OS (zip) file to the SD Card.
3. Create a file called "ssh" in the root of the sd card.
4. If you are not using a ethernet connection with internet access, you will need to configure the Wifi access point settings before putting the SD card into the Raspberry Pi.
5. Create a file called "wpa_supplicant.conf" in the root of the sd card with this content.

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev<br>
update_config=1<br>
country=US or AU (other allowed)<br>

network={<br>
  ssid="Your Network SSID" <br>
  psk="Your WPA/WPA2 security key" <br>
  scan_ssid=1<br>
}<br>

<b>Final configuration steps on Raspberry Pi</b><br>
6. Insert the SD card into the Raspberry Pi and power up.<br>
7. Connect your PC to the same ethernet or WiFi network that you specified above.<br>
8. Using terminal, ssh onto the raspberry Pi.  ssh pi@raspberrypi.local or IP address<br>
9. Install and configure using:<br>
```sh
$ wget -q https://git.io/vhvRl -O /tmp/pi-iot-sense && bash /tmp/pi-iot-sense
```
10. Reboot.<br>
11. Check operation.<br>

<b>Clean-up of SD card for distribution.</b><br>
12. browse to http://raspberrypi.local on the connected network, remove the wifi client connection.<br>
12. SD card is ready for distribution.<br>
