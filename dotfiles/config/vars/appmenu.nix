{ isXorg ? false, isWayland ? false, pkgs, ... }:
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

  stop = label: command:
    exec label
    "sh -c 'systemctl --user stop graphical-session.target ; ${command}'";

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

  applicationsMain = menu "applications-main" "Main" ((onlyWayland [
    (exec "wezterm"
      "env __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json wezterm --config enable_wayland=false")
    (exec "wterm" "weston-terminal")
    (menu "applications-waydroid" "Waydroid" [
      (exec "Start" (script "waydroid-start"))
      (exec "Stop" (script "waydroid-stop"))
    ])
  ]) ++ (onlyXorg [
    (exec "wezterm" "wezterm")
    "${sep}"
    (exec "waydroid" (script "waydroid-on-weston"))
  ] ++ [ "${sep}" (exec "Vial" "Vial") ]));

  applicationsVM = menu "applications-vm" "VM" [
    (exec "Virt Manager" "virt-manager")
    (exec "Virt Viewer" "virt-viewer -c qemu:///system -a")
    "${sep}"
    (exec "Looking Glass" "looking-glass-client")
  ];

  applicationsWeb = menu "applications-web" "Web" [
    (exec "Firefox" "firefox")
    (exec "Thunderbird" "thunderbird")
    (exec "Google Chrome" "google-chrome-stable")
    "${sep}"
    (exec "Scrapbox" "google-chrome-stable --app=https://scrapbox.io/")
    "${sep}"
    (exec "1password" "1password")
    (exec "Bitwarden" "bitwarden")
    "${sep}"
    (exec "Telegram"
      "env QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt6.qtbase.qtPluginPrefix} telegram-desktop")
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
    (exec "DeaDBeef" "deadbeef")
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
    (stop "Exit" "openbox --exit")
    "${sep}"
    (exec "Lock" "xset dpms force off")
    (stop "Logout" "loginctl terminate-session self")
    "${sep}"
    (stop "Reboot" "systemctl reboot")
    (stop "Shutdown" "shutdown -h now")
  ];

  systemOperationWayland = menu "system-operation" "System" [
    (action "Reconfigure" "Reconfigure")
    (stop "Exit" "labwc --exit")
    "${sep}"
    (exec "Lock" "swaylock -C ~/.config/swaylock/config -f")
    (stop "Logout" "loginctl terminate-session self")
    "${sep}"
    (stop "Reboot" "systemctl reboot")
    (stop "Shutdown" "shutdown -h now")
  ];

  systemOperation =
    if isXorg then systemOperationXorg else systemOperationWayland;

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
in ''
  <?xml version="1.0" encoding="UTF-8"?>
  <openbox_menu xmlns="http://openbox.org/3.4/menu">
    ${applicationsMain}
    ${applicationsVM}
    ${applicationsWeb}
    ${applicationsFiles}
    ${applicationsMultimedia}
    ${applicationsOffice}
    ${applicationsUtils}
    ${systemOperation}
    ${systemContextMenu}
  </openbox_menu>
''
