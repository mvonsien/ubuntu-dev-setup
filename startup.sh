#!/bin/bash -i

echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient"

read -p "Enter your GIT user.name [Marian Vonsien]: " git_config_user_name
git_config_user_name=${git_config_user_name:-Marian Vonsien}
read -p "Enter your GIT user.email [marianvon29@gmail.com]: " git_config_user_email
git_config_user_email=${git_config_user_email:-marianvon29@gmail.com}
read -p "Enter your github username [marianvon29]: " username
username=${username:-mvonsien}

cd ~ && sudo apt update && sudo apt upgrade -y

echo 'Installing vim' 
sudo apt install vim -y

echo 'Installing curl' 
sudo apt install curl -y

echo 'Installing neofetch' 
sudo apt install neofetch -y

echo 'Installing some basic packages'
sudo apt install libfuse2 ca-certificates gnupg lsb-release mercurial make binutils gcc build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl -y

echo 'Installing xclip with aliases (copy, paste)'
sudo apt install xclip -y
echo 'alias copy="xclip -selection clipboard"' >> ~/.bash_aliases
echo 'alias paste="xclip -selection clipboard -o"' >> ~/.bash_aliases
. ~/.bash_aliases

echo 'Installing latest git' 
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update && sudo apt install git -y

echo 'Installing python3-pip'
sudo apt install python3-pip -y

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

echo 'Generating a SSH Key'
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C $git_config_user_email
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | copy
echo 'Copied public SSH key to clipboard'

echo 'Installing pyenv'
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv --version
pyenv install 3
pyenv global 3
python --version

echo 'Installling pdm'
curl -sSL https://pdm-project.org/install-pdm.py | python -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"

echo 'Installing bison and gvm'
sudo apt install bison -y
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm

echo 'Installing go 1.4, 1.17, 1.20'
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.17.13
gvm use go1.17.13
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.20
gvm use go1.20
go version

echo 'Installing NVM' 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


echo 'Installing NodeJS LTS'
nvm --version
nvm install --lts
nvm current
echo 'NPM version: ' && npm -v

echo 'Installing Yarn'
npm install --global yarn
yarn -v

echo 'Installing Prettier'
npm install --global prettier
echo "$(which prettier): $(prettier -v)"

echo 'Installing VSCode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install apt-transport-https -y
sudo apt update && sudo apt install code -y

echo 'Installing Code Settings Sync'
code --install-extension Shan.code-settings-sync
sudo apt install gnome-keyring -y

echo 'Uinstalling old Docker versions'
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt remove $pkg; done

echo 'Installing docker and docker-compose'
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock
docker run --rm hello-world

docker --version
docker compose version

echo 'Installing Postman'
sudo snap install postman

echo 'Installing Jetbrains Toolbox'
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash

echo 'Installing VLC'
sudo apt install vlc -y
sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y
sudo dpkg-reconfigure libdvd-pkg --force

echo 'Installing Discord'
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt install -f -y && rm discord.deb

echo 'Installing Zoom'
sudo apt install libxcb-xtest0 libxcb-cursor0 ibus desktop-file-utils
wget -c https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom_amd64.deb
sudo apt install -f -y && rm zoom_amd64.deb

echo 'Installing Diodon (clipboard history manager)'
sudo apt update
sudo apt install diodon -y
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Control><Super>v']"
echo 'For it to work with a shortcut, create a shortcut under Settings > Keyboard > Keyboard Shortcuts > View and Customize Shortcuts > Custom Shortcuts > Add Shortcut...'
echo 'As name enter the name for the shortcut (e.g. "Diodon"), as command enter "/usr/bin/diodon" and as shortcut select whatever you would like (e.g. "Super+V")'
read -p "Press [ENTER] to continue when you have set up your shortcut"


echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt update; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'


echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'All setup, enjoy!'
