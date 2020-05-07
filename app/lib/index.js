
'use strict';

const electron = require('electron');
const path = require('path');
const open = require('open');
const nativeImage = require('electron').nativeImage;

const Tray = electron.Tray;
const Menu = electron.Menu;
let shouldQuit = false;
let tray;

const app = electron.app;
app.on('ready', () => {
  const initialIcon = path.join(app.getAppPath(), 'lib/assets/icons/icon-128x128.png');
  const window = new electron.BrowserWindow({
    width: 980,
    height: 685,
    icon:"/usr/share/icons/workchat.png",
    webPreferences: {
      partition: 'persist:workplace-chat',
      //preload: path.join(__dirname, 'notifications.js'),
      nodeIntegration: false
    }
  });

  tray = new Tray(initialIcon);
  tray.setToolTip('Workspace Chat');
  tray.on('click', () => {
    if (window.isFocused()) {
      window.hide();
    } else {
      window.show();
      window.focus();
    }
  });

  tray.setContextMenu(new Menu.buildFromTemplate(
    [
      {
        label: 'Refresh',
        click: () => {
          window.show();
          window.reload();
        }
      },
      {
        label: 'Quit',
        click: () => {
          shouldQuit = true;
          app.quit();
        }
      }
    ]
  ));

  window.on('close', (event) => {
    if (!shouldQuit) {
      event.preventDefault();
      window.hide();
    } else {
      app.quit();
    }
  });
	
  electron.ipcMain.on('notifications', (event, {count, icon}) => {
    try {
      const image = nativeImage.createFromDataURL(icon);
      tray.setImage(image);
      window.flashFrame(count > 0);
    } catch (err) {
      console.error(`Could not update tray icon: ${err.message}`)
    }
  });

  window.webContents.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Workplace/1.0.76 Chrome/69.0.3497.128 Electron/4.2.8 Safari/537.36 [FBAN/WorkplaceDesktop;FBAV/1.0.76;FBDV/darwin;FBSV/19.0.0]');
  window.loadURL('https://work.facebook.com/chat/');  
});
