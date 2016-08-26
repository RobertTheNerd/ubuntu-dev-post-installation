#!bin/bash

# get jdk tar file. https://gist.github.com/RobertTheNerd/aa96c79ffcf4d417f193ffb406555667
EXT="tar.gz"
JDK_VERSION="8"

if [ -n "$1" ]; then
  if [ "$1" == "tar" ]; then
    EXT="tar.gz"
  fi
fi

URL="http://www.oracle.com"
JDK_DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
JDK_DOWNLOAD_URL2=`curl -s $JDK_DOWNLOAD_URL1 | egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${JDK_VERSION}-downloads-.+?\.html" | head -1`
if [ -z "$JDK_DOWNLOAD_URL2" ]; then
  echo "Could not get jdk download url - $JDK_DOWNLOAD_URL1"
  exit 1
fi

JDK_DOWNLOAD_URL3="${URL}${JDK_DOWNLOAD_URL2}"
JDK_DOWNLOAD_URL4=`curl -s $JDK_DOWNLOAD_URL3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.${EXT}" | tail -1`

pushd /tmp
wget --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  -O jdk.tar.gz \
  $JDK_DOWNLOAD_URL4

if [ ! -d /opt/java/versions ]; then
    sudo mkdir -p /opt/java/versions
fi


popd

