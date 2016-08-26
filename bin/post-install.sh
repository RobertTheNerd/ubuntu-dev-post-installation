#!/bin/bash

# NOPASSWD in sudoer for current user
echo "$USER  ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# update & upgrade
sudo apt-get update; sudo apt-get upgrade -y

# install git
sudo apt-get install git;

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

# install go



# install ssh-server

# install app-grid
sudo add-apt-repository ppa:appgrid/stable -y
sudo apt-get update
sudo apt-get install appgrid -y


