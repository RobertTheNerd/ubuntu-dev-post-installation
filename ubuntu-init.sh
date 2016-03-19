#!/bin/bash

# NOPASSWD in sudoer for current user
echo "$USER\tALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a sudoers > /dev/null

# update & upgrade
sudo apt-get update; sudo apt-get upgrade -y

# install zsh & oh-my-zsh
sudo apt-get install zsh -y

# install tmux
sudo apt-get install tmux -y

# install go

# install ssh-server

# install app-grid
sudo add-apt-repository ppa:appgrid/stable -y
sudo apt-get update
sudo apt-get install appgrid -y


