# upgrade-retropie-buster

1. Resize /boot to 256 MB

1. update openbor scriptmodule

    ```sh
    wget https://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/scriptmodules/openbor-6xxx-RPi4/openbor-v6510-RPi4.sh -O- | tr -d '\r' > /home/pi/RetroPie-Setup/scriptmodules/ports/openbor-v6510-RPi4.sh
    ```

1. make sure you're up to date before starting

    ```sh
    sudo apt-get update
    sudo apt-get -y dist-upgrade
    ```

1. replace in sources

    ```sh
    sudo sed -i 's/stretch/buster/g' /etc/apt/sources.list
    sudo sed -i 's/stretch/buster/g' /etc/apt/sources.list.d/raspi.list
    ```

1. remove apt-listchanges to save time

    ```sh
    sudo apt-get remove apt-listchanges
    ```

1. do the upgrade

    ```sh
    sudo apt-get update
    sudo apt-get -y dist-upgrade
    sudo apt-get install firmware-misc-nonfree
    ```

1. clean up

    ```sh
    sudo apt-get -y autoremove --purge
    sudo apt-get -y autoclean
    ```

1. update Retropie setup script

1. update lr-fbneo from binary, if it's on source

1. run Retropie Setup update with os packages

1. re-install all non-libretro packages, remove scraper

1. install new openbor

1. update emulators.cfg for openbor and remove old openbor directory

1. remove bashwelcometweak then install it

1. Review [Audio Issues](https://retropie.org.uk/forum/topic/26628/audio-issues-after-latest-raspbian-updates)
