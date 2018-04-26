(function () {
  const electron = require('electron');
  const remote = electron.remote;
  const NativeImage = electron.nativeImage;

  function setOverlay(mailCount, jiraCount, notifCount) {
    const canvas = document.createElement('canvas');
    canvas.height = 140;
    canvas.width = 140;
    const image = new Image();
    image.crossOrigin = 'anonymous';
    image.onload = function () {
      const ctx = canvas.getContext('2d');
      ctx.drawImage(image, 0, 0, 140, 140);
      if (mailCount > 0 || jiraCount > 0 || notifCount > 0) {
        if ((mailCount > 0 || jiraCount > 0) && notifCount > 0) {
          ctx.fillStyle = 'fuchsia';
        } else if (mailCount > 0 && jiraCount > 0) {
          ctx.fillStyle = 'teal';
        } else if (jiraCount > 0) {
          ctx.fillStyle = 'aqua';
        } else if (mailCount > 0) {
          ctx.fillStyle = 'red';
        } else {
          ctx.fillStyle = 'lime';
        }
        ctx.beginPath();
        ctx.ellipse(105, 35, 35, 35, 35, 0, 2 * Math.PI);
        ctx.fill();
        ctx.textAlign = 'center';
        ctx.fillStyle = 'white';

        ctx.font = 'bold 70px "Segoe UI","Helvetica Neue",Helvetica,Arial,sans-serif';
        let count = mailCount + jiraCount + notifCount;
        if (count > 9) {
          ctx.fillText('+', 105, 60);
        } else {
          ctx.fillText(count.toString(), 105, 60);
        }
      }

      const badgeDataURL = canvas.toDataURL();
      const img = NativeImage.createFromDataURL(badgeDataURL);
      electron.ipcRenderer.send('notifications', {
        count: mailCount+notifCount,
        icon: badgeDataURL
      });
    };
    image.src = document.querySelector("link[rel*='icon']").href;
  }

  function poll(lastMailCount, lastJiraCount, lastNotifCount) {
    try {
      let mailCount = jQuery("span[title*='Inbox'] + div > span").first().text();
      let jiraCount = jQuery("span[title*='JIRA'] + div > span").first().text();
      let notifCount = jQuery(".o365cs-flexPane-unseenCount").text();
      mailCount = (mailCount > 0 ? parseInt(mailCount) : 0);
      jiraCount = (jiraCount > 0 ? parseInt(jiraCount) : 0);
      notifCount = (notifCount > 0 ? parseInt(notifCount) : 0);
      if (mailCount !== lastMailCount || jiraCount != lastJiraCount || notifCount !== lastNotifCount) {
        setOverlay(mailCount, jiraCount, notifCount);
      }
      setTimeout(poll, 1000, mailCount, jiraCount, notifCount);
    } catch (err) {
      setTimeout(poll, 1000, lastMailCount, lastJiraCount, lastNotifCount);
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    poll(0);
  });

  // Disable Workplace icon (top left)
  jQuery('._2z9u').attr("href", "#");

})();
