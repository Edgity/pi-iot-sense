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

<b>Upgrade OS</b><br>
9. sudo apt-get update && sudo apt-get upgrade<br>
10. sudo rpi-update<br>

<b>Install AirMon-ng for wifi monitoring mode</b><br>
11. #sudo apt-get -y install libssl-dev libnl-3-dev libnl-genl-3-dev ethtool<br>
11. sudo apt-get install build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev libsqlite3-dev libpcre3-dev ethtool shtool rfkill zlib1g-dev libpcap-dev<br>
12. wget  https://download.aircrack-ng.org/aircrack-ng-1.3.tar.gz<br>
13. tar -zxvf aircrack-ng-1.3.tar.gz<br>
14. cd aircrack-ng-1.3<br>
14a. autoreconf -i<br>
14b. ./configure<br>
15. sudo make<br>
16. sudo make install<br>
17. sudo airodump-ng-oui-update<br>

<b>To Check monitoring mode</b><br>
a. sudo s airmon-ng start wlan0<br>
b. sudo airodump-ng wlan0mon<br>

<b>Install Web Client Management tools</b>
18. Install and configure using:<br>
```sh
$ wget -q https://git.io/vhvRl -O /tmp/pi-iot-sense && bash /tmp/pi-iot-sense
```
19. Reboot.<br>
20. Check operation.<br>

<b>Clean-up of SD card for distribution.</b><br>
21. browse to http://raspberrypi.local on the connected network, remove the wifi client connection.<br>
22. SD card is ready for distribution.<br>
