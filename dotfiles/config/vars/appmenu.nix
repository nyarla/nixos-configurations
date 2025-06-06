{ lib }:
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

  jack =
    cmd:
    let
      set-samplerate = "pw-metadata -n settings 0 clock.force-rate 96000";
      set-buffer = "pw-metadata -n settings 0 clock.force-quantum 512";
    in
    ''sh -c "${set-samplerate} ; ${set-buffer} ; QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 pw-jack ${cmd}"'';

  mainList = list "Main" (id "main") [
    (run "Terminal" "mlterm-wl")
    (list "Virtual Machine" (id "vm") [
      (run "Virtual Machine Manager" "virt-manager")
      (run "Looking Glass" "looking-glass-client")
      (run "Remmina" "remmina")
      sep
      (run "Take Snapshot" "bash /etc/nixos/dotfiles/files/scripts/vm-snapshot-for-daw")
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
    (run "Video" "vlc")
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

  sysutilList = list "Configure" (sys "util") [
    (run "Audio" "pwvucontrol")
    (run "Bluetooth" "blueman-manager")
    (run "DroidCam" "droidcam")
    sep
    (run "Keychain" "seahorse")
    sep
    (run "Task Manager" "missioncenter")
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
    (list "Illustration" (id "illustration") [
      (run "Gimp" "gimp")
      (run "Inkspace" "inkscape")
      sep
      (run "Krita" "krita")
    ])
    (list "PixelArt" (id "pixelart") [
      (run "Pixelorama" "pixelorama --rendering-driver vulkan --gpu-index 0 --display-driver wayland")
      (run "Aseprite" "aseprite")
    ])
    sep
    (list "DAW" (id "daw") [
      (run "Bitwig Studio" (jack "bitwig-studio"))
      (run "Heilo Workstation" (jack "helio"))
      (run "MuseScore" (jack "mscore"))
      (run "Zrythm" (jack "bash /etc/nixos/dotfiles/files/scripts/zrythm-launch"))
      sep
      (run "FamiStudio" "FamiStudio")
      sep
      (run "Sononym" (jack "sononym"))
    ])
    (list "Plugins" (id "plugins") [
      (run "Carla" (jack "carla"))
      (run "Ildaeil" (jack "Ildaeil"))
      sep
      (run "AudioGridder" (jack "AudioGridderServer"))
    ])
    (list "VSinger" (id "vsynger") [
      (run "VoiceVox" "voicevox")
      (run "OpenUtau" "OpenUtau")
    ])
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
