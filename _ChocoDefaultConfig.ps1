# bash
curl -Lo "$Env:USERPROFILE\.bashrc" https://raw.githubusercontent.com/cscribn/config-misc/main/bash/bashrc-win

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"

curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings.json

# oh-my-posh
$GitDir = "$Env:USERPROFILE\.config\oh-my-posh"
$GitUrl = "https://github.com/cscribn/config-oh-my-posh.git"
$Clone = $FALSE

If (-Not (Test-Path -Path $GitDir)) {
	$Clone = $TRUE
} Else {
	Set-Location $GitDir
	git fetch
	$GitMain = git rev-parse main
	$GitOrigin = git rev-parse origin/main
	Set-Location -

	If ($GitMain -ne $GitOrigin) {
		Remove-Item -Recurse -Force $GitDir
		$Clone = $TRUE
	}
}

If ($Clone) {
	git clone $GitUrl $GitDir
}

# powershell-core
curl -Lo "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" https://raw.githubusercontent.com/cscribn/config-misc/main/powershell-core/Microsoft.PowerShell_profile.ps1

# vim
Set-Location "$Env:USERPROFILE"

curl -Lo ".vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

Copy-Item ".vimrc" -Destination "_vimrc"
Set-Location -

# zsh
$GitDir = "$Env:USERPROFILE\.config\zsh"
$GitUrl = "https://github.com/cscribn/config-zsh.git"
$Clone = $FALSE

If (-Not (Test-Path -Path $GitDir)) {
	$Clone = $TRUE
} Else {
	Set-Location $GitDir
	git fetch
	$GitMain = git rev-parse main
	$GitOrigin = git rev-parse origin/main
	Set-Location -

	If ($GitMain -ne $GitOrigin) {
		Remove-Item -Recurse -Force $GitDir
		$Clone = $TRUE
	}
}

If ($Clone) {
	git clone $GitUrl $GitDir

	Copy-Item -Force -Path "$GitDir\zshrc-win" -Destination "$Env:USERPROFILE\.zshrc"
	Copy-Item -Recurse -Force -Path "$GitDir\zsh.ico" -Destination "C:\Program Files\Git\usr\share\icons\locolor\32x32\apps"
}
