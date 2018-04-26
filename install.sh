#!/bin/bash

LOCALDIR="$(dirname "$(readlink -f "$0")")"
WORKDIR=/tmp/workplace-chat
INSTALLDIR=/opt/workplace-chat

npm help &>/dev/null
if [ $? != 0 ]; then
	echo "NPM need to be installed first, exiting..."
	exit 1
fi

sudo mkdir -p $INSTALLDIR $WORKDIR
sudo cp -r ${LOCALDIR}/* $WORKDIR
cd $WORKDIR
npm install
cd $WORKDIR
npm install
cd ${WORKDIR}/node_modules/wmctrl
sudo npm install

sudo cp -r $WORKDIR $INSTALLDIR
sudo install -m 755 ${INSTALLDIR}/app/bin/workplace-chat /usr/local/bin/
install -m 755 ${INSTALLDIR}/app/bin/workplace-chat.desktop ~/.local/share/applications
install -m 755 ${INSTALLDIR}/app/bin/workplace-chat.desktop ~/Desktop
