#!/opt/homebrew/bin/bash

# Set environment & paths
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export SUDO_ASKPASS="/Users/appfire-chadscribner/.ssh/secrets/.supwd.sh"
export USERNAME="appfire-chadscribner"

# Move to directory
cd /Users/appfire-chadscribner/projects/package-manage || exit 1

# Execute workload
{ git pull; ./mac-work.sh; /usr/local/bin/pwsh ./PwshMac.ps1; } >> ./package-manage.log 2>&1
