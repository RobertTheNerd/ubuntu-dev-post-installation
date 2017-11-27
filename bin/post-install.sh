#!/bin/bash

# get script folders. http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

post_install() {
    # NOPASSWD in sudoer for current user
    sudo sh -c "sed -i \"/$USER/d\" /etc/sudoers; echo \"$USER  ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers.d/$USER"

    # update & upgrade
    sudo apt-get update; sudo apt-get upgrade -y

    # install curl
    sudo apt install curl -y

    # git
    sudo apt-get install git tree -y;

    # zsh & oh-my-zsh
    sudo apt-get install zsh -y
    sh -c "$(wget https://raw.githubusercontent.com/RobertTheNerd/oh-my-zsh/master/tools/install.sh -O -)"
    
    # vmware mount
    mkdir ~/Shared
    echo '[ "$(ls -A ~/Shared)"  ] || vmhgfs-fuse -o uid=1000 -o gid=1000 .host:/ ~/Shared' >> ~/.zshrc

    # install & config tmux
    sudo apt-get install tmux -y
    echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf

    # vim and Ultimate vimrc
    # sudo apt-get install vim -y
    # git clone https://github.com/RobertTheNerd/vimrc.git ~/.vim_runtime
    # sh ~/.vim_runtime/install_awesome_vimrc.sh

    # ssh-server
    sudo apt-get install openssh-server -y
    sudo ufw allow 22

    # PHP & Apache. Use docker for mysql
    # sudo apt-get install apache2 php -y

    # docker
    sudo apt-get install --no-install-recommends \
        apt-transport-https \
        curl \
        software-properties-common
    curl -fsSL 'https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | sudo apt-key add -
    sudo add-apt-repository \
        "deb https://packages.docker.com/1.12/apt/repo/ \
        ubuntu-$(lsb_release -cs) \
        main"
    sudo apt-get update
    sudo apt-get -y install docker-engine

    # dotnet core, https://www.microsoft.com/net/core#linuxubuntu
    # curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    # sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    # sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
    # sudo apt-get update
    # sudo apt-get install -y dotnet-sdk-2.0.0
    
    # Node.js
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs

    # google-chrome
    # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    # sudo dpkg -i google-chrome-stable_current_amd64.deb
    # sudo apt-get install -fy
    # rm google-chrome-stable_current_amd64.deb

    # sublime text, https://gist.github.com/simonewebdesign/8507139
    # wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    # sudo apt-get install apt-transport-https
    # echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # sudo apt-get update
    # sudo apt-get install sublime-text

    # Indicator Netspeed 
    # wget "http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/i/indicator-netspeed/indicator-netspeed_0+git20140722-0~webupd8~xenial_amd64.deb" -O indicator.deb
    # sudo dpkg -i indicator.deb
    # rm indicator.deb

    # app-grid
    # sudo add-apt-repository ppa:appgrid/stable -y
    # sudo apt-get update
    # sudo apt-get install appgrid -y
}

post_install
