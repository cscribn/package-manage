# Non-Chocolatey installations (add/update these first)
# alienware update universal
# backblaze
# papercut mobility print

. $PSScriptRoot\_ChocoDefault.ps1

choco upgrade nvidia-display-driver -y
choco upgrade plexmediaserver -y

choco feature enable -n useRememberedArgumentsForUpgrades
choco upgrade all -y
