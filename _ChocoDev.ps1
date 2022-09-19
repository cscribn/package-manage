choco upgrade github-desktop -y

# node
choco upgrade nvm -y
choco upgrade nvm.install -y
nvm uninstall latest
nvm install latest
nvm use latest

choco upgrade strawberryperl -y
choco upgrade python -y
choco upgrade xmlstarlet -y
choco upgrade vscode -y
choco upgrade vscode.install -y
