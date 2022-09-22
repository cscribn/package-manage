choco upgrade github-desktop -y

# node
choco upgrade nvm -y
nvm uninstall latest
nvm install latest
nvm use latest

choco upgrade strawberryperl -y

# python
choco uninstall python -y
choco install python -y
$PythonPath = Resolve-Path "C:\Python3*\python.exe"
$PythonWPath = Resolve-Path "C:\Python3*\pythonw.exe"
Rename-Item -Path "$PythonPath" -NewName "python3.exe"
Rename-Item -Path "$PythonWPath" -NewName "pythonw3.exe"
choco upgrade python2 -y

# ruby
choco uninstall ruby -y
choco install ruby -y
Update-SessionEnvironment
ridk install 2 3

choco upgrade xmlstarlet -y
choco upgrade vscode -y
