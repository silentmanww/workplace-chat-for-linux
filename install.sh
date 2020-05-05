#!/bin/bash

WORKDIR=/tmp
INSTALLDIR=/opt
APPNAME="workplace-chat"
#RELEASE=$(lsb_release -is)
LOCALDIR="$(dirname "$(readlink -f "$0")")"

npm help &>/dev/null
if [ $? != 0 ]; then
	echo "NPM need to be installed first, exiting..."
	exit 1
fi

sudo rm -rf ${WORKDIR}/${APPNAME} ${INSTALLDIR}/${APPNAME} /usr/local/bin/${APPNAME}
mkdir ${WORKDIR}/${APPNAME}
cp -r ${LOCALDIR}/* ${WORKDIR}/${APPNAME}
cd ${WORKDIR}/${APPNAME}/app
npm install
cd ${WORKDIR}/${APPNAME}
npm install

sudo cp -r ${WORKDIR}/${APPNAME} $INSTALLDIR
sudo install -m 755 ${INSTALLDIR}/${APPNAME}/app/bin/${APPNAME} /usr/local/bin/
install -m 755 ${INSTALLDIR}/${APPNAME}/app/bin/workplace-chat.desktop ~/.local/share/applications
sudo rm -rf ${INSTALLDIR}/${APPNAME}/app/bin
sudo cp ${INSTALLDIR}/${APPNAME}/app/lib/assets/icons/workchat.png /usr/share/icons
