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
in ''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">

  ${makeMenu "applications-main" "Main" [
    (makeExecute "terminal" "wezterm")
    (makeExecute "git gui" "gitg")
    (isMe ''
      ${makeExecute "virt-manager" "virt-manager"}
      ${makeExecute "weston" (scriptsCmd "waydroid-on-weston")}
      ${makeExecute "waydroid" "waydroid show-full-ui"}
    '')
  ]}

  ${makeMenu "applications-web" "Web" [
    (makeExecute "Firefox" "firefox")
    (makeExecute "Thunderbird" "thunderbird")
    (isMe ''
      ${(makeExecute "Google Chrome" "google-chrome-stable")}
      ${(makeExecute "Brave" "brave")}
    '')
    "${sep}"
    (makeExecute "1password" "1password")
    (isMe ''
      ${sep}
      ${(makeExecute "Tuba" "dev.geopjr.Tuba")}
    '')
  ]}

  ${makeMenu "applications-file" "Files" [
    (makeExecute "Thunar" "thunar")
    (makeExecute "Atril" "atril")
    (makeExecute "Pluma" "pluma")
  ]}

  ${makeMenu "applications-multimedia" "Multimedia" [
    (makeExecute "Calibre" "calibre")
    (makeExecute "Picard" "picard")
    (makeExecute "Mp3tag" (wineCmd "Mp3tag"))
    "${sep}"
    (makeExecute "Tenacity" "tenacity")
    "${sep}"
    (makeExecute "DeaDBeeF" "deadbeef")
    (makeExecute "Amazon Music" (wineCmd "AmazonMusic"))
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
    (makeExecute "Audio" "pavucontrol")
    (makeExecute "Bluetooth" "blueman-manager")
    (makeExecute "Droidcam" "droidcam")
    "${sep}"
    (makeExecute "Seahorse" "seahorse")
    "${sep}"
    (makeExecute "Disk Utility" "gnome-disks")
    (makeExecute "Usage" "gnome-usage")
    "${sep}"
    (makeExecute "System monitor" "mate-system-monitor")
  ]}

  ${makeMenu "system-actions" "System" [
    (makeAction "Reconfigure" "Reconfigure")
    (makeExecute "Lock" "xset dpms force off")
    (makeExecute "Logout" "loginctl terminate-user nyarla")
    "${sep}"
    (makeExecute "Reboot" "systemctl reboot")
    (makeExecute "Shutdown" "systemctl poweroff")
  ]}

  ${makeMenu "root-menu" "Openbox" [
    (makeMenuItem "applications-main")
    (makeMenuItem "applications-file")
    "${sep}"
    (makeMenuItem "applications-web")
    (isMe ''
      ${makeMenuItem "applications-multimedia"}
      ${sep}
      ${(makeMenuItem "applications-office")}
    '')
    "${sep}"
    (makeMenuItem "system-utils")
    (makeMenuItem "system-actions")
  ]}
  </openbox_menu>
''
