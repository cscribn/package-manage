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
Set-FTA LibreOffice.CalcDocument.1 .csv; `
Set-FTA LibreOffice.CalcDocument.1 .xls; `
Set-FTA LibreOffice.CalcDocument.1 .xlsx; `
Set-FTA LibreOffice.WriterDocument.1 .doc; `
Set-FTA LibreOffice.WriterDocument.1 .docx; `
Set-FTA LibreOffice.ImpressDocument.1 .ppt; `
Set-FTA LibreOffice.ImpressDocument.1 .pptx; `
Set-FTA VLC.avi .avi; `
Set-FTA VLC.flac .flac; `
Set-FTA VLC.flv .flv; `
Set-FTA VLC.m4a .m4a; `
Set-FTA VLC.m4v .m4v; `
Set-FTA VLC.mov .mov; `
Set-FTA VLC.mp3 .mp3; `
Set-FTA VLC.mpeg .mpeg; `
Set-FTA VLC.mpg .mpg; `
Set-FTA VLC.rm .rm; `
Set-FTA VLC.swf .swf; `
Set-FTA VLC.wav .wav; `
Set-FTA VLC.wmv .wmv
