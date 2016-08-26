#!/bin/bash

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
