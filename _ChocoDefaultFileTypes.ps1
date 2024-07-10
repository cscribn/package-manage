$GitDir = "C:\PS-SFTA"; If (Test-Path $GitDir) { Set-Location $GitDir; & "C:\Program Files\Git\bin\git" pull; Set-Location - } Else { & "C:\Program Files\Git\bin\git" clone "https://github.com/DanysysTeam/PS-SFTA.git" $GitDir }; `
. $GitDir\SFTA.ps1; `
Set-FTA IrfanView.bmp .bmp; `
Set-FTA IrfanView.gif .gif; `
Set-FTA IrfanView.heic .heic; `
Set-FTA IrfanView.jpg .jpeg; `
Set-FTA IrfanView.jpg .jpg; `
Set-FTA IrfanView.png .png; `
Set-FTA IrfanView.tif .tif; `
Set-FTA IrfanView.webp .webp; `
Set-FTA VLC.mp3 .mp3; `
Set-FTA VLC.mpeg .mpeg

# TODO movies and audio files
