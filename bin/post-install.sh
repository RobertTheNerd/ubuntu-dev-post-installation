#!/bin/bash

# get script folders. http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# install jdk
install_jdk() {
    CURRENT_FOLDER=$(readlink -f .)

    # get jdk tar file. https://gist.github.com/RobertTheNerd/aa96c79ffcf4d417f193ffb406555667
    EXT="tar.gz"
    JDK_VERSION="8"

    URL="http://www.oracle.com"
    JDK_DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
    JDK_DOWNLOAD_URL2=`curl -s $JDK_DOWNLOAD_URL1 | egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${JDK_VERSION}-downloads-.+?\.html" | head -1`
    if [ -z "$JDK_DOWNLOAD_URL2" ]; then
      echo "Could not get jdk download url - $JDK_DOWNLOAD_URL1"
      exit 1
    fi

    JDK_DOWNLOAD_URL3="${URL}${JDK_DOWNLOAD_URL2}"
    JDK_DOWNLOAD_URL4=`curl -s $JDK_DOWNLOAD_URL3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.${EXT}" | tail -1`

    # create folder
    JAVA_FOLDER=/opt/java
    JDK_FOLDER=$JAVA_FOLDER/versions
    if [ ! -d ${JDK_FOLDER} ]; then
        sudo mkdir -p ${JDK_FOLDER}
    fi

    cd $JDK_FOLDER
    sudo wget --no-cookies \
     --no-check-certificate \
     --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     -q -O jdk.tar.gz \
     $JDK_DOWNLOAD_URL4 

    # get current folder for jdk
    RELEASE_FOLDER=`tar tzf jdk.tar.gz | head -1 | cut -f1 -d"/"`
    echo $RELEASE_FOLDER

    sudo tar xfz jdk.tar.gz; sudo rm jdk.tar.gz

    sudo ln -fs ${JDK_FOLDER}/$RELEASE_FOLDER $JAVA_FOLDER/current

# add environment variable
    if ! grep -q JAVA_HOME /etc/profile; then
        echo "
# Java settings
export JAVA_HOME=$JAVA_FOLDER/current
export PATH=\$PATH:\$JAVA_HOME/bin
" | sudo tee -a /etc/profile > /dev/null

    fi

    cd $CURRENT_FOLDER
}


post_install() {
    # NOPASSWD in sudoer for current user
    sudo sh -c "sed -i \"/$USER/d\" /etc/sudoers; echo \"$USER  ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers.d/$USER"

    # update & upgrade
    sudo apt-get update; sudo apt-get upgrade -y

    # git
    sudo apt-get install git tree -y;

    # zsh & oh-my-zsh
    sudo apt-get install zsh -y
    sh -c "$(wget https://raw.githubusercontent.com/RobertTheNerd/oh-my-zsh/master/tools/install.sh -O -)"

    # install & config tmux
    sudo apt-get install tmux -y
    echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf

    # vim and Ultimate vimrc
    sudo apt-get install vim -y
    git clone https://github.com/RobertTheNerd/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    # ssh-server
    sudo apt-get install openssh-server -y
    sudo ufw allow 22

    # PHP & Apache. Use docker for mysql
    sudo apt-get install apache2 php -y

    # docker
    curl -sSL https://get.docker.com/ | sh
    sudo usermod -aG docker $USER

    # dotnet core, https://www.microsoft.com/net/core#linuxubuntu
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
    sudo apt-get updatesudo apt-get install dotnet-sdk-2.0.0

    # google-chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get install -fy
    rm google-chrome-stable_current_amd64.deb

    # sublime text, https://gist.github.com/simonewebdesign/8507139
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text

    # Indicator Netspeed 
    wget "http://ppa.launchpad.net/nilarimogard/webupd8/ubuntu/pool/main/i/indicator-netspeed/indicator-netspeed_0+git20140722-0~webupd8~xenial_amd64.deb" -O indicator.deb
    sudo dpkg -i indicator.deb
    rm indicator.deb

    # app-grid
    sudo add-apt-repository ppa:appgrid/stable -y
    sudo apt-get update
    sudo apt-get install appgrid -y
}

post_install
