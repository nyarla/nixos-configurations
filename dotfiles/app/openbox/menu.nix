{ isMe, ... }:
let
  makeExecute = label: command: ''
    <item label="${label}">
      <action name="Execute">
        <command>${command}</command>
      </action>
    </item>
  '';

  makeAction = label: action: ''
    <item label="${label}">
      <action name="${action}" />
    </item>
  '';

  makeMenu = id: label: items: ''
    <menu id="${id}" label="${label}">
      ${builtins.concatStringsSep "\n" items}
    </menu>
  '';

  makeMenuItem = id: ''
    <menu id="${id}"/>
  '';

  sep = ''
    <separator />
  '';

  scripts = "bash /etc/nixos/dotfiles/files/scripts";
  scriptsCmd = cmd: "${scripts}/${cmd}";

  wine = "/etc/nixos/dotfiles/files/wine";
  wineCmd = app: "bash ${wine}/${app}";

  iLokCmd = prefix: "${wine}/iLok ${prefix}";
in ''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">

  ${makeMenu "applications-main" "Main" [
    (makeExecute "mlterm" "mlterm")
    (isMe ''
      ${makeExecute "virt-manager" "virt-manager"}
      ${makeExecute "weston" (scriptsCmd "waydroid-on-weston")}
      ${makeExecute "waydroid" "waydroid show-full-ui"}
    '')
  ]}

  ${makeMenu "applications-web" "Web" [
    (makeExecute "Firefox" "firefox")
    (makeExecute "Thunderbird" "thunderbird")
    (makeExecute "Google Chrome" "google-chrome-stable")
    "${sep}"
    (isMe "${makeExecute "Trickle" (scriptsCmd "trickle")}")
    (makeExecute "Whalebird" "whalebird")
    "${sep}"
    (makeExecute "1password" "1password")
  ]}

  ${makeMenu "applications-file" "Files" [
    (makeExecute "Thunar" "thunar")
    (makeExecute "Atril" "atril")
    (makeExecute "Pluma" "pluma")
    (makeExecute "GHex" "ghex")
  ]}

  ${makeMenu "applications-multimedia" "Multimedia" [
    (makeExecute "Calibre" "calibre")
    (makeExecute "QuodLibet" "quodlibet")
    (makeExecute "Picard" "picard")
    (makeExecute "Mp3tag" (wineCmd "Mp3tag"))
    "${sep}"
    (makeExecute "Audacity" "audacity")
    (makeExecute "DeaDBeeF" "deadbeef")
    "${sep}"
    (makeExecute "Kindle" (wineCmd "Kindle"))
    (makeExecute "Amazon Music" (wineCmd "AmazonMusic"))
  ]}

  ${makeMenu "applications-chat" "Chat" [
    (makeExecute "Droidcam" "droidcam")
    (makeExecute "Slack" "slack")
    (makeExecute "Discord" "discord")
    (makeExecute "Telegram" "telegram-desktop")
  ]}

  ${makeMenu "applications-office" "Office" [
    (makeExecute "Calc" "mate-calc")
    (makeExecute "Char Maps" "gucharmap")
    "${sep}"
    (makeExecute "Gimp" "gimp")
    (makeExecute "Inkscape" "inkscape")
    "${sep}"
    (makeExecute "Spice up" "com.github.philip-scott.spice-up")
    (makeExecute "Simple Scan" "simple-scan")
    (makeExecute "GIF capture" "peek")
  ]}

  ${makeMenu "system-utils" "Utilities" [
    (makeExecute "QJackCtl" "qjackctl")
    (makeExecute "Audio" "pavucontrol")
    (makeExecute "Bluetooth" "blueman-manager")
    "${sep}"
    (makeExecute "Seahorse" "seahorse")
    "${sep}"
    (makeExecute "Disk Utility" "gnome-disks")
    (makeExecute "Usage" "gnome-usage")
    "${sep}"
    (makeExecute "Task manager" "sysmontask")
    (makeExecute "System monitor" "mate-system-monitor")
  ]}

  ${makeMenu "system-actions" "System" [
    (makeAction "Reconfigure" "Reconfigure")
    (makeExecute "Lock" "xset dpms force off")
    (makeExecute "Logout" "loginctl terminate-user nyarla")
  ]}

  ${makeMenu "root-menu" "Openbox" [
    (makeMenuItem "applications-main")
    (makeMenuItem "applications-file")
    "${sep}"
    (makeMenuItem "applications-web")
    (isMe ''
      ${makeMenuItem "applications-multimedia"}
    '')
    "${sep}"
    (makeMenuItem "applications-office")
    (makeMenuItem "applications-chat")
    "${sep}"
    (makeMenuItem "system-utils")
    (makeMenuItem "system-actions")
  ]}
  </openbox_menu>
''
