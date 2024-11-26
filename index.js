const { app, BrowserWindow, Tray, Menu, nativeImage, ipcMain } = require('electron');
const screenshot = require('screenshot-desktop');
const path = require('path');

let mainWindow;
let tray;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 400,
    height: 300,
    webPreferences: {
      nodeIntegration: true,
    }
  });

  mainWindow.loadFile(path.join(__dirname, 'index.html'));
  mainWindow.on('closed', function () {
    mainWindow = null;
  });
} 
app.on('ready', () => {
  createWindow(); 
  captureTrayIcons();
});

function captureTrayIcons() {
  screenshot({ format: 'png' }).then((img) => {
    const imageBase64 = `data:image/png;base64,${img.toString('base64')}`;
    const iconImage = nativeImage.createFromDataURL(imageBase64);

    // Удалить предыдущую иконку трея, если она была создана ранее
    if (tray) {
      tray.destroy();
    }

    // Создание новой иконки трея
    tray = new Tray(iconImage);

    // Обновление информации в главном окне приложения через IPC
    mainWindow.webContents.send('update-tray-info', { imageBase64, contextMenu: tray.getContextMenu() });

    // Установка контекстного меню для иконки трея
    const contextMenu = Menu.buildFromTemplate([
      { label: 'Item 1', type: 'normal', click: () => console.log('Clicked Item 1') },
      { label: 'Item 2', type: 'separator' },
      { label: 'Exit', type: 'normal', click: () => app.quit() }
    ]);

    tray.setToolTip('My Electron App');
    tray.setContextMenu(contextMenu);
    // Обработка двойного щелчка по иконке трея
    tray.on('double-click', () => mainWindow.show());
  }).catch((err) => {
    console.error('Error capturing tray icons:', err);
  });
}

// Пример обработки IPC от главного процесса
ipcMain.handle('get-tray-info', (event) => {
  // Здесь можно реализовать логику получения информации из системного трея
  return { message: 'Tray info requested' };
});
