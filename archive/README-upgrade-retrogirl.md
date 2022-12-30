# upgrade-retrogirl

Perform the following steps only if the sources have been updated [Raspberry-Pi-Installer-Scripts](https://github.com/adafruit/Raspberry-Pi-Installer-Scripts/)

## Install PiTFT (fbcp) Support

```sh
cd ~
curl -O https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/pitft-fbcp.sh
sudo bash pitft-fbcp.sh
```

* CONTINUE? y
* Select project: 1
* CONTINUE? y
* REBOOT NOW? N

## Installing Keypress (retrogame) support

```sh
cd ~
curl -O https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/retrogame.sh
sudo bash retrogame.sh
```

* SELECT: 1
