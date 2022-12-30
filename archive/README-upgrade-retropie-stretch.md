# upgrade-retropie-stretch

```sh
sudo sed -i 's/jessie/stretch/g' /etc/apt/sources.list
sudo sed -i 's/jessie/stretch/g' /etc/apt/sources.list.d/raspi.list

sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y purge "pulseaudio*"

sudo apt-get -y autoremove --purge
sudo apt-get -y autoclean
```
