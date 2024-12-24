{ lib, ... }:
let
  inherit (import ./xml.nix { inherit lib; }) labwc;
  inherit (labwc)
    action
    run
    sep
    list
    include
    script
    wine
    id
    sys
    ;

  exec = label: command: ''
    <item label="${label}">
      <action name="Execute">
        <command>${command}</command>
      </action>
    </item>
  '';

  stop =
    label: commandline:
    run label "sh -c 'systemctl --user stop graphical-session.target ; ${commandline}'";

  menu = id: label: contains: ''
    <menu id="${id}" label="${label}">
      ${builtins.concatStringsSep "\n" contains}
    </menu>
  '';

  mainList = list "Main" (id "main") [
    (run "Terminal" "mlterm-wl")
    (list "Virtual Machine" (id "vm") [
      (run "Virtual Machine Manager" "virt-manager")
      (run "Looking Glass" "looking-glass-client")
      (run "Remmina" "remmina")
    ])
    (list "Waydroid" (id "waydroid") [
      (script "start" "waydroid-start")
      (script "stop" "waydroid-stop")
    ])
    (run "Vial" "Vial")
  ];

  internetList = list "Internet" (id "internet") [
    (run "Firefox" "firefox")
    (run "Thunderbird" "thunderbird")
    sep
    (run "Google Chrome" "google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")
    sep
    (run "Aria" "aria")
    (run "Telegram" "telegram-desktop")
    sep
    (run "Bitwaden" "bitwarden --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")
  ];

  filesList = list "Files" (id "files") [
    (run "Files" "Thunar")
    (run "eBooks" "calibre")
    (wine "Kindle" "Kindle")
    sep
    (run "Documents" "atril")
    (run "Music" "deadbeef")
    sep
    (run "Text Edit" "pluma")
    sep
    (run "Picard" "picard")
    (run "EasyTag" "easytag")
  ];

  officeList = list "Office" (id "office") [
    (run "Calc" "mate-calc")
    (run "CharMap" "gucharmap")
    sep
    (run "Scanner" "simple-scan")
  ];

  applicationsCreative = menu "applications-creative" "Creative" [
    (exec "Gimp" "gimp")
    (exec "Inkscape" "inkscape")
    (exec "Krita" "krita")
    (exec "Pixelorama" "pixelorama")
    (exec "Libresprite" "libresprite")
  ];

  sysutilList = list "Configure" (sys "util") [
    (run "Audio" "pwvucontrol")
    (run "Bluetooth" "blueman-manager")
    (run "DroidCam" "droidcam")
    sep
    (run "Keychain" "seahorse")
    sep
    (run "Task Manager" "mate-system-monitor")
  ];

  sysDisplayList = list "Display" (sys "display") [
    (run "Always ON" "systemctl --user stop swaylock")
    (run "Enable AutoLock" "systemctl --user start swaylock")
  ];

  sysOperationList = list "System" (sys "operation") [
    (action "Reconfigure" "Reconfigure")
    sep
    (run "Lock" "swaylock -C ~/.config/swaylock/config -f")
    sep
    (stop "Logout" "loginctl terminate-session self")
    (stop "Exit" "labwc --exit")
    sep
    (stop "Reboot" "systemctl reboot")
    (stop "Shutdown" "shutdown -h now")
  ];

  contextCreativeRoot = list "Creative" (id "creative") [
    (run "Gimp" "gimp")
    (run "Inkscape" "inkscape")
    (run "Krita" "krita")
  ];

  contextMenuRoot = list "Menu" "root-menu" [
    (include (id "main"))
    (include (id "internet"))
    (include (id "files"))
    (include (id "office"))
    sep
    (include (sys "util"))
    (include (sys "display"))
    (include (sys "operation"))
  ];
in
labwc.openbox [
  mainList
  internetList
  filesList
  officeList

  sysutilList
  sysDisplayList
  sysOperationList

  contextMenuRoot
  contextCreativeRoot
]
