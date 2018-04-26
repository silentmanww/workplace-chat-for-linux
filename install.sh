#!/bin/bash

npm help &>/dev/null
if [ $? != 0 ]; then
	echo "NPM need to be installed first, exiting..."
	exit 1
fi

cd app
npm install
cd ..
npm install

INSTALLDIR=/opt/workplacechat
sudo mkdir -p $INSTALLDIR
sudo cp -r * $INSTALLDIR
sudo install -m 755 ${INSTALLDIR}/app/bin/workplace-chat /usr/local/bin/
install -m 755 ${INSTALLDIR}/app/bin/workplacechat.desktop ~/Desktop
