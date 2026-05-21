# Disable firewall for private network
Set-NetFirewallProfile -Profile Private -Enabled False

# Flush the DNS cache
ipconfig /flushdns

# Clears NetBIOS cache
nbtstat -R

# Refreshes NetBIOS registration
nbtstat -RR
