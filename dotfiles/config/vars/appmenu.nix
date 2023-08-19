{ isXorg ? false, isWayland ? false, ... }:
let
  onlyWayland = contains: if isWayland then contains else [ ];
  onlyXorg = contains: if isXorg then contains else [ ];

  exec = label: command: ''
    <item label="${label}">
      <action name="Execute">
        <command>${command}</command>
      </action>
    </item>
  '';

  menu = id: label: contains: ''
    <menu id="${id}" label="${label}">
      ${builtins.concatStringsSep "\n" contains}
    </menu>
  '';

  action = label: action: ''
    <item label="${label}">
      <action name="${action}" />
    </item>
  '';

  item = id: ''
    <menu id="${id}"/>
  '';

  script = name: "bash /etc/nixos/dotfiles/files/scripts/${name}";
  wine = name: "bash /etc/nixos/dotfiles/files/wine/${name}";

  sep = "<separator/>";

  applicationsMain = menu "applications-main" "Main"
    ([ (exec "wezterm" "wezterm") ]
      ++ (onlyWayland [ (exec "wterm" "weston-terminal") ])
      ++ (onlyXorg [ (exec "waydroid" (script "waydroid-on-weston")) ]
        ++ [ "${sep}" (exec "Vial" "Vial") ]));

  applicationsWeb = menu "applications-web" "Web" [
    (exec "Firefox" "firefox")
    (exec "Thunderbird" "thunderbird")
    (exec "Google Chrome" "google-chrome-stable")
    (exec "Brave" "brave")
    "${sep}"
    (exec "1password" "1password")
  ];

  applicationsFiles = menu "applications-files" "Files" [
    (exec "Thunar" "thunar")
    (exec "Atril" "atril")
    (exec "Pluma" "pluma")
  ];

  applicationsMultimedia = menu "applications-multimedia" "Media" [
    (exec "Calibre" "calibre")
    (exec "Picard" "picard")
    (exec "Mp3tag" (wine "Mp3tag"))
    "${sep}"
    (exec "Audaticy" "audacity")
    "${sep}"
    (exec "DeaDBeef" "deadbeef")
    (exec "Amazon Music" (wine "AmazonMusic"))
  ];

  applicationsOffice = menu "applications-office" "Office" [
    (exec "Calc" "mate-calc")
    (exec "CharMap" "gucharmap")
    "${sep}"
    (exec "Gimp" "gimp")
    (exec "Inkscape" "inkscape")
    "${sep}"
    (exec "Spice up" "com.github.philip-scott.spice-up")
    (exec "Simple Scan" "simple-scan")
    (exec "GIF Capture" "peek")
  ];

  applicationsUtils = menu "applications-utils" "Utils" [
    (exec "Audio" "pavucontrol")
    (exec "Bluetooth" "blueman-manager")
    (exec "DroidCam" "droidcam")
    "${sep}"
    (exec "Vault" "seahorse")
    "${sep}"
    (exec "Task Manager" "mate-system-monitor")
  ];

  systemOperationXorg = menu "system-operation" "System" [
    (action "Reconfigure" "Reconfigure")
    (exec "Lock" "xset dpms force off")
    (exec "Logout"
      "sh -c 'systemctl --user stop lxqt-panel; loginctl terminate-session self'")
    "${sep}"
    (exec "Reboot" "sh -c 'systemctl --user stop lxqt-panel; systemctl reboot'")
    (exec "Shutdown" "shutdown -h now")
  ];

  systemOperationWayland = menu "system-operation" "System" [ ];

  systemOperation =
    if isXorg then systemOperationXorg else systemOperationWayland;

  systemContextMenu = menu "root-menu" "Menu" [
    (item "applications-main")
    (item "applications-web")
    (item "applications-files")
    (item "applications-multimedia")
    (item "applications-office")
    (item "applications-utils")
    (item "system-operation")
  ];
in ''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">
    ${applicationsMain}
    ${applicationsWeb}
    ${applicationsFiles}
    ${applicationsMultimedia}
    ${applicationsOffice}
    ${applicationsUtils}
    ${systemOperation}
    ${systemContextMenu}
  </openbox_menu>
''
