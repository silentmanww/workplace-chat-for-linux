#!/bin/bash

npm help
if [ $? != 0 ]; then
	echo "NPM need to be installed first, exiting..."
	exit 1
fi

cd app
npm install
cd ..
npm install

INSTALLDIR=/opt/workplacechat
mkdir $INSTALLDIR
install -m 755 * $INSTALLDIR
install -m 755 lib/workplacechat ~/Desktop
