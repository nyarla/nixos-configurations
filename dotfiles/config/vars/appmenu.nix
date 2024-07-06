_:
let
  exec = label: command: ''
    <item label="${label}">
      <action name="Execute">
        <command>${command}</command>
      </action>
    </item>
  '';

  stop =
    label: command: exec label "sh -c 'systemctl --user stop graphical-session.target ; ${command}'";

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

  applicationsMain = menu "applications-main" "Main" [
    (exec "mlterm" "mlterm-wl")
    (exec "virt-manager" "virt-manager")
    (exec "looking-glass" "looking-glass-client")
    "${sep}"
    (menu "applications-wayland" "waydroid" [
      (exec "start" (script "waydroid-start"))
      (exec "stop" (script "waydroid-stop"))
    ])
    "${sep}"
    (exec "vial" "Vial")
  ];

  applicationsWeb = menu "applications-web" "Web" [
    (exec "Firefox" "firefox")
    (exec "Thunderbird" "thunderbird")
    (exec "Google Chrome" "google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")
    "${sep}"
    (exec "bitwarden" "bitwarden --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")
    "${sep}"
    (exec "Telegram" "telegram-desktop")
  ];

  applicationsFiles = menu "applications-files" "Files" [
    (exec "Thunar" "thunar")
    (exec "Atril" "atril")
    (exec "Pluma" "pluma")
  ];

  applicationsMultimedia = menu "applications-multimedia" "Media" [
    (exec "Calibre" "calibre")
    (exec "Kindle" (wine "Kindle"))
    "${sep}"
    (exec "Picard" "picard")
    (exec "Easytag" "easytag")
    "${sep}"
    (exec "DeaDBeef" "deadbeef")
  ];

  applicationsOffice = menu "applications-office" "Office" [
    (exec "Calc" "mate-calc")
    (exec "CharMap" "gucharmap")
    "${sep}"
    (exec "Simple Scan" "simple-scan")
  ];

  applicationsCreative = menu "applications-creative" "Creative" [
    (exec "Gimp" "gimp")
    (exec "Inkscape" "inkscape")
    (exec "Krita" "krita")
    (exec "Pixelorama" "pixelorama")
    (exec "Libresprite" "libresprite")
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

  systemOperation = menu "system-operation" "System" [
    (action "Reconfigure" "Reconfigure")
    (stop "Exit" "labwc --exit")
    "${sep}"
    (exec "Lock" "swaylock -C ~/.config/swaylock/config -f")
    (stop "Logout" "loginctl terminate-session self")
    "${sep}"
    (stop "Reboot" "systemctl reboot")
    (stop "Shutdown" "shutdown -h now")
  ];

  systemContextMenu = menu "root-menu" "Menu" [
    (item "applications-main")
    (item "applications-vm")
    (item "applications-web")
    (item "applications-files")
    (item "applications-multimedia")
    (item "applications-office")
    (item "applications-utils")
    (item "system-operation")
  ];
in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">
    ${applicationsMain}
    ${applicationsWeb}
    ${applicationsFiles}
    ${applicationsMultimedia}
    ${applicationsOffice}
    ${applicationsUtils}
    ${applicationsCreative}
    ${systemOperation}
    ${systemContextMenu}
  </openbox_menu>
''
