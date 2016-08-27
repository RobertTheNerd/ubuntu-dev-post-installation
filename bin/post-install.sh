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

# install LAMP
sudo apt-get install apache2 mysql php -y

# install jdk -- begin --
# get jdk tar file. https://gist.github.com/RobertTheNerd/aa96c79ffcf4d417f193ffb406555667
EXT="tar.gz"
JDK_VERSION="8"

pushd /tmp

URL="http://www.oracle.com"
JDK_DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
JDK_DOWNLOAD_URL2=`curl -s $JDK_DOWNLOAD_URL1 | egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${JDK_VERSION}-downloads-.+?\.html" | head -1`
if [ -z "$JDK_DOWNLOAD_URL2" ]; then
  echo "Could not get jdk download url - $JDK_DOWNLOAD_URL1"
  exit 1
fi

JDK_DOWNLOAD_URL3="${URL}${JDK_DOWNLOAD_URL2}"
JDK_DOWNLOAD_URL4=`curl -s $JDK_DOWNLOAD_URL3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.${EXT}" | tail -1`

wget --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  -O jdk.tar.gz \
  $JDK_DOWNLOAD_URL4

# create folder
JDK_FOLDER=/opt/java/versions
if [ ! -d ${JDK_FOLDER} ]; then
    sudo mkdir -p ${JDK_FOLDER}
fi

# get current folder for jdk
RELEASE_FOLDER=`tar tzf jdk.tar.gz | head -1 | cut -f1 -d"/"`
echo $RELEASE_FOLDER

cd $JDK_FOLDER
sudo tar xvfz /tmp/jdk.tar.gz 
sudo ln -fs ${JDK_FOLDER}/$RELEASE_FOLDER current

# add environment variable
if ! grep -q JAVA_HOME /etc/profile; then
    echo "
# Java settings
export JAVA_HOME=$JDK_FOLDER/current
export PATH=\$PATH:\$JAVA_HOME/bin
" | sudo tee -a /etc/profile > /dev/null

fi

# clean up 
rm /tmp/jdk.tar.gz

popd
# install jdk -- end --

# isntall google-chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f
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
