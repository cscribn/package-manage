# Flush the DNS cache
ipconfig /flushdns

# Release and renew the DHCP lease
ipconfig /release; `
ipconfig /renew

# Clear and rebuild the ARP cache
arp -d *

# Remove stale SMB sessions
net use * /delete /y

# Restart Workstation and Server services (these handle SMB connections)
net stop workstation /y; `
net start workstation; `
net start sessionenv; `
net stop server /y; `
net start server

# Restart Docker Desktop Service (if it exists)
if (Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue) { `
    Restart-Service -Name "com.docker.service" -Force `
}
