#!/bin/bash

# LATEST_BROWSERMOB=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
LATEST_BROWSERMOB=2.1.4

echo 'Downloading Browsermob ' $LATEST_BROWSERMOB
if [ "$(uname)" == "Darwin" ]; then
  echo 'on OSX 64'
  curl -L https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-$LATEST_BROWSERMOB/browsermob-proxy-$LATEST_BROWSERMOB-bin.zip  >> browsermob-proxy-$LATEST_BROWSERMOB.zip
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo 'on Linux 64'
  curl -L https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-$LATEST_BROWSERMOB/browsermob-proxy-$LATEST_BROWSERMOB-bin.zip  >> browsermob-proxy-$LATEST_BROWSERMOB.zip
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  echo 'on Windows 32'
  curl -L https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-$LATEST_BROWSERMOB/browsermob-proxy-$LATEST_BROWSERMOB-bin.zip  >> browsermob-proxy-$LATEST_BROWSERMOB.zip
fi

unzip browsermob-proxy-$LATEST_BROWSERMOB.zip
mv browsermob-proxy-$LATEST_BROWSERMOB /usr/bin/browsermob-proxy
rm browsermob-proxy-$LATEST_BROWSERMOB.zip
