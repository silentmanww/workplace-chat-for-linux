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

#if [[ $RELEASE =~ .*[A|a]"rch".* ]]; then
#	sudo pacman -Ssy &>/dev/null
#	sudo pacman -S wmctrl --needed --noconfirm &>/dev/null
#elif [[ $RELEASE =~ .*[C|c]"ent"[O|o][S|s].* ]] || [[ $RELEASE =~ .*[R|r]"ed"[H|h]at.* ]] || [[ $RELEASE =~ .*[F|f]"edora".* ]]; then
#	sudo yum -y install wmctrl &>/dev/null
#elif [[ $RELEASE =~ .*[U|u]"buntu".* ]] || [[ $RELEASE =~ .*[D|d]"ebian".* ]]; then
#	sudo apt update &>/dev/null
#	sudo apt install -y wmctrl &>/dev/null
#fi

sudo cp -r ${WORKDIR}/${APPNAME} $INSTALLDIR
sudo install -m 755 ${INSTALLDIR}/${APPNAME}/app/bin/${APPNAME} /usr/local/bin/
install -m 755 ${INSTALLDIR}/${APPNAME}/app/bin/workplace-chat.desktop ~/.local/share/applications
install -m 755 ${INSTALLDIR}/${APPNAME}/app/bin/workplace-chat.desktop ~/Desktop
