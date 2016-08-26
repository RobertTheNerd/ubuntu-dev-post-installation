#!/bin/bash

# get script folders. http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# NOPASSWD in sudoer for current user
echo "$USER  ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# update & upgrade
sudo apt-get update; sudo apt-get upgrade -y

# install git
sudo apt-get install git tree -y;

# install zsh & oh-my-zsh
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# install & config tmux
sudo apt-get install tmux -y
echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf

# install vim and Ultimate vimrc
sudo apt-get install vim -y
git clone https://github.com/RobertTheNerd/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# install ssh-server
sudo apt-get install openssh-server -y
sudo ufw allow 22

# install jdk
source $SCRIPTPATH/install-jdk.sh

# isntall google-chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# install sublime text, https://gist.github.com/simonewebdesign/8507139
curl -L git.io/sublimetext | sh

# install Indicator Netspeed 
wget "http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/i/indicator-netspeed/indicator-netspeed_0+git20140722-0~webupd8~xenial_amd64.deb" -O indicator.deb
sudo dpkg -i indicator.deb
rm indicator.deb

# install app-grid
sudo add-apt-repository ppa:appgrid/stable -y
sudo apt-get update
sudo apt-get install appgrid -y


