choco upgrade github-desktop -y

# node
choco upgrade nvm -y
nvm uninstall latest
nvm install latest
nvm use latest

choco upgrade strawberryperl -y

# python
choco upgrade python -y
$PythonPath = Resolve-Path "C:\Python3*\python.exe"
$PythonWPath = Resolve-Path "C:\Python3*\pythonw.exe"
Rename-Item -Path "$PythonPath" -NewName "python3.exe"
Rename-Item -Path "$PythonWPath" -NewName "pythonw3.exe"
choco upgrade python2 -y

choco upgrade xmlstarlet -y
choco upgrade vscode -y
