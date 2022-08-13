_:
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

  scripts = "/etc/nixos/dotfiles/files/scripts";
  scriptsCmd = cmd: "${scripts}/${cmd}";

  wine = "/home/nyarla/local/dotfiles/wine";
  wineCmd = app: "${wine}/${app}";
  iLokCmd = prefix: ''
    bash -c &#34;cd &#39;/run/media/nyarla/src/local/daw/plugins/${prefix}&#39; &amp;&amp; wine-run wine explorer &#39;C:\Program Files (x86)\iLok License Manager\iLok License Manager.exe&#39;&#34;
  '';

in ''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">

  ${makeMenu "applications-main" "Main" [
    (makeExecute "mlterm" "mlterm-wl")
    (makeExecute "virt-manager" "virt-manager")
  ]}

  ${makeMenu "applications-web" "Web" [
    (makeExecute "Firefox" "firefox")
    (makeExecute "Thunderbird" "thunderbird")
    (makeExecute "Google Chrome" "google-chrome-stable")
    (makeExecute "Bitwarden" "bitwarden --no-sandbox")
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
    (makeExecute "Audacity" "nice -n -19 audacity")
    (makeExecute "DeaDBeeF" "deadbeef")
    "${sep}"
    (makeExecute "Kindle" (wineCmd "Kindle"))
    (makeExecute "Amazon Music" (wineCmd "AmazonMusic"))
  ]}

  ${makeMenu "applications-chat" "Chat" [
    (makeExecute "Droidcam" "droidcam")
    (makeExecute "Slack" "slack --disable-gpu")
    (makeExecute "Discord" "discord --no-sandbox")
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
    (makeExecute "GIF capture" "env GDK_BACKEND=x11 peek")
  ]}

  ${makeMenu "applications-daw" "Music" [
    (makeExecute "QJackCtl" "qjackctl")
    (makeExecute "Carla" "carla")

    (makeMenu "submenu-daw" "DAW" [
      (makeExecute "Bitwig Studio" "bitwig-studio")
      (makeExecute "Zrythm" "zrythm")
      (makeExecute "Helio.fm" "helio")
      (makeExecute "MuseScore" "musescore")
      "${sep}"
      (makeExecute "FL Studio" (wineCmd "FLStudio"))
      (makeExecute "deCoda" (wineCmd "deCoda"))
    ])

    (makeMenu "submenu-authorizer" "Authorizer" [
      (makeExecute "Arturia" (wineCmd "Arturia"))
      (makeExecute "eLicenser" (wineCmd "eLicenser"))
      (makeExecute "Native Access" (wineCmd "NativeAccess"))
      (makeExecute "IK Multimedia" (wineCmd "IKMultimedia"))
    ])

    (makeMenu "submenu-ilok" "iLok" [
      (makeExecute "AMT" (iLokCmd "AMT"))
      (makeExecute "SONiVOX" (iLokCmd "SONiVOX"))
    ])
  ]}

  ${makeMenu "system-utils" "Utilities" [
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
    (makeExecute "Reconfigure" "pkill -x -SIGHUP labwc")
    (makeExecute "Lock" "swaylock")
    (makeAction "Logout" "Exit")
    (makeExecute "Reboot" "systemctl reboot")
  ]}

  ${makeMenu "root-menu" "Labwc" [
    (makeMenuItem "applications-main")
    (makeMenuItem "applications-file")
    "${sep}"
    (makeMenuItem "applications-web")
    (makeMenuItem "applications-multimedia")
    (makeMenuItem "applications-daw")
    "${sep}"
    (makeMenuItem "applications-office")
    (makeMenuItem "applications-chat")
    "${sep}"
    (makeMenuItem "system-utils")
    (makeMenuItem "system-actions")
  ]}
  </openbox_menu>
''
