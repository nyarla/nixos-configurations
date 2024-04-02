{ isXorg ? false, isWayland ? false, pkgs, ... }:
let
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

  exec2 = label:
    { wayland ? "", xorg ? "" }:
    if isWayland then (exec label wayland) else (exec label xorg);

  applicationsMain = menu "applications-main" "Main" [
    (exec2 "mlterm" {
      wayland = "mlterm-wl";
      xorg = "mlterm-sdl2";
    })
    (exec "virtualbox" "VirtualBox")
    "${sep}"
    (if isWayland then
      (menu "applications-wayland" "waydroid" [
        (exec "start" (script "waydroid-start"))
        (exec "stop" (script "waydroid-stop"))
      ])
    else
      (exec "waydroid" (script "waydroid-on-weston")))
    "${sep}"
    (exec "vial" "Vial")
  ];

  applicationsWeb = menu "applications-web" "Web" [
    (exec "Firefox" "firefox")
    (exec "Thunderbird" "thunderbird")
    (exec2 "Google Chrome" {
      wayland = "google-chrome-stable --ozone-platform=x11";
      xorg = "google-chrome-stable";
    })
    "${sep}"
    (exec2 "Bitwarden" {
      wayland = "bitwarden --disable-gpu";
      xorg = "bitwarden";
    })
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
    (exec "Picard" "picard")
    (exec "Mp3tag" (wine "MP3TAG"))
    "${sep}"
    (exec "DeaDBeef" "deadbeef")
  ];

  applicationsOffice = menu "applications-office" "Office" [
    (exec "Calc" "mate-calc")
    (exec "CharMap" "gucharmap")
    "${sep}"
    (exec "Spice up" "com.github.philip_scott.spice-up")
    (exec "Simple Scan" "simple-scan")
    (exec2 "GIF Capture" {
      wayland = "GDK_BACKEND=x11 peek";
      xorg = "peek";
    })
  ];

  applicationsCreative = menu "applications-creative" "Creative" [
    (menu "applications-daw" "DAW" [
      (exec "FL Studio" (wine "FLStudio"))
      (exec "deCoda" (wine "deCoda"))
      (exec "Bitwig Studio 3" "bitwig-studio")
      (exec "MuseScore 4" "mscore")
      (exec "Helio workstation" "helio")
      "${sep}"
      (exec "Sononym" "sononym")
      "${sep}"
      (exec "Carla" "carla")
      (exec "Ildaeil" "Ildaeil")
      "${sep}"
      (exec "QJackctl" "qjackctl")
    ])
    "${sep}"
    (menu "applications-graphic" "Graphics" [
      (exec "Gimp" "gimp")
      (exec "Inkscape" "inkscape")
      (exec "Krita" "krita")
      (exec "Pixelorama" "pixelorama")
      (exec "Libresprite" "libresprite")
    ])
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
