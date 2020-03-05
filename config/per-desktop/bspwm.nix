{ config, pkgs, ... }:
let
  apps = with pkgs; [
    polybarFull dunst rofi
    bspwm sxhkd
  ];

  addToXDGDirs = p: ''
    if test -d "${p}/share"; then
      case "''${XDG_DATA_DIRS}" in
        *:${p}/share:*) ;;
        *) export XDG_DATA_DIRS=''${XDG_DATA_DIRS}:${p}/share
      esac
    fi

    if test -d "${p}/lib/girepository-1.0"; then
      case "''${GI_TYPELIB_PATH}" in
        *:${p}/lib/girepository-1.0:*) ;;
        *) export GI_TYPELIB_PATH=''${GI_TYPELIB_PATH}:${p}/lib ;;  
      esac

      case "''${LD_LIBRARY_PATH}" in
        *:${p}/lib:*) ;;
        *) export LD_LIBRARY_PATH=''${LD_LIBRARY_PATH}:${p}/lib ;;
      esac
    fi

    if test -d "${p}/lib/gio" ; then
      case "''${GIO_EXTRA_MODULES}" in
        *:${p}/lib/gio/modules:*) ;;
        *) export GIO_EXTRA_MODULES=''${GIO_EXTRA_MODULES}:${p}/lib/gio/modules ;;
      esac
    fi
  '';

  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides" {}
  ''
    mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    cp -rf ${pkgs.gnome3.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml \
      $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

    ${pkgs.stdenv.lib.concatMapStrings (p: ''
      if test -d ${p}/share/gsettings-schemas; then
        cp -rf ${p}/share/gsettings-schemas/*/glib-2.0/schemas/* \
          $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
      fi
    '') (config.environment.systemPackages ++ [ config.i18n.inputMethod.package ] ++ apps )}

    ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
  '';

  polybar = pkgs.writeText "polybar" ''
    [colors]
    gray-brightest = #FFFFFF
    gray-brighter  = #F8F9F9
    gray-bright    = #CCCCCC
    gray-dark      = #666666
    gray-darker    = #333333
    gray-darkest   = #000000

    red-bright     = #FF0000
    red-dark       = #CC0000

    orange-bright  = #FF6633
    orange-dark    = #CC6600

    yellow-bright  = #FFCC33
    yellow-dark    = #CC9900

    lime-bright    = #CCFF00
    lime-dark      = #99CC00

    green-bright   = #00CC00
    green-dark     = #009900

    mint-bright    = #00CC99
    mint-dark      = #009966

    cyan-bright    = #00CCCC
    cyan-adark     = #009999

    sky-bright     = #00CCFF
    sky-dark       = #0099CC

    blue-bright    = #0000FF
    blue-dark      = #0000CC

    purple-bright  = #9900CC
    purple-dark    = #660099

    magenta-bright = #CC00CC
    magenta-dark   = #990099

    wine-bright    = #CC3366
    wine-dark      = #990033

    [bar/main]
    monitor  = eDP-1
    # monitor = rdp0
    offset-x = 0
    offset-y = 0
    width    = 3840 
    height   = 48

    font-0 = "MyricaM M:size=24;3"
    font-1 = "Symbols Nerd Font:size=24;3"

    background = #81191919
    foreground = #F0F9F9

    border-size   = 0

    module-margin-left  = 1
    modules-left   = userhost title
    modules-center = bspwm
    modules-right  = datetime cpu memory volume network battery

    tray-position = right
    tray-maxsize  = 32
    tray-scale    = 1.0

    line-size = 3
    line-color = ''${colors.gray-brighter}

    [module/bspwm]
    type = internal/bspwm
    enable-click = true
    enable-scroll = true

    label-focused = "%icon% %name% "
    label-focused-underline = ''${colors.lime-bright}

    label-occupied = "%icon% %name% "
    label-occupied-underline = ''${colors.sky-bright}

    label-uegent = "%icon% %name% "
    label-urgent-background = ''${colors.red-bright}
    label-urgent-foreground = ''${colors.gray-brightest}

    label-empty = "%icon% %name% "
    label-empty-foreground = ''${colors.gray-bright}

    [module/title]
    type = internal/xwindow
    format = <label>
    label = %{F#CCFF00}%{F-} %{B}%title%%{B-}
    label-maxlen = 64

    [module/volume]
    type = internal/pulseaudio
    sink = alsa_output.pci-0000_00_1f.3.analog-stereo

    use-ui-max = false
    interval   = 1

    format-volume = %{A2:polybar-pulseaudio-volume.sh 2 &:}%{A3:pavucontrol &:}<ramp-volume> <label-volume>%{A}%{A}
    format-mute   = %{A2:polybar-pulseaudio-volume.sh 2 &:}%{A3:pavucontrol &:}<label-mute>%{A}{A}

    label-volume  = %percentage%%
    label-muted   = %{F#FF6633}%{F-} ---

    ramp-volume-0 = %{F#00CCFF}%{F-}
    ramp-volume-1 = %{F#CCFF00}%{F-}
    ramp-volume-2 = %{F#FFCC33}%{F-}

    [module/battery]
    type    = internal/battery
    battery = BAT0
    adapter = AC

    time-format = %H:%M

    format-charging     = "%{F#FFCC00}%{F-} %percentage%% <ramp-capacity>"
    format-discharging  = "%{F#CCCCCD}%{F-} %percentage% <ramp-capacity>"
    format-full         = "%{F#CCFF00}%{F-} 100% <ramp-capacity>"

    ramp-capacity-0 = %{F#FF0000}%{F-}
    ramp-capacity-1 = %{F#FF6633}%{F-}
    ramp-capacity-2 = %{F#FFCC33}%{F-}
    ramp-capacity-3 = %{F#CCFF00}%{F-}
    ramp-capacity-4 = %{F#CCFF00}%{F-}

    [module/network]
    type      = internal/network
    interface = wlp2s0
    format-connected    = %{F#9CD9F0}%{F-} <label-connected>
    format-disconnetted = %{F#5D5D5D}%{F-} <label-disconnected>

    label-connected     = %essid%
    label-disconnected  = none

    [module/datetime]
    type = internal/date
    interval = 1.0

    date   = %Y-%m-%d
    time   = %H:%M:%S (%a)
    format = %{F#00CCCC}%{F-} <label>
    label  = %{A1:zenity --calendar --text Display &:}%date%T%time%%{A}


    [module/userhost]
    type = custom/script
    exec = "sh -c 'echo $(id -un)@$(hostname)'"
    tail = false
    format = "%{F#00CCFF} %{F-} <label>"

    [module/cpu]
    type    = internal/cpu
    format  = <ramp-load>

    ramp-load-0 = %{F#72B3CC}▁%{F-}
    ramp-load-1 = %{F#72B3CC}▂%{F-}
    ramp-load-2 = %{F#8EB33B}▃%{F-}
    ramp-load-3 = %{F#8EB33B}▄%{F-}
    ramp-load-4 = %{F#D0B03B}▅%{F-}
    ramp-load-5 = %{F#D0B03B}▆%{F-}
    ramp-load-6 = %{F#C75646}▇%{F-}
    ramp-load-7 = %{F#C75646}█%{F-}

    [module/memory]
    type    = internal/memory
    format  = %{F#5D5D5D}%{F-} <label>
    label   = %gb_used:0:4%GB

  '';

  polybarLaunch = pkgs.writeScript "launch" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.procps}/bin/pkill polybar
    while ${pkgs.procps}/bin/pkill -u $UID -x polybar >/dev/null; do sleep 1; done

    case "''${PATH}" in
      *:/etc/nixos/scripts:*) ;;
      *) export PATH=/etc/nixos/scripts:$PATH
    esac

    ${pkgs.polybarFull}/bin/polybar -c ${polybar} main &
  '';

  bspwmRules = pkgs.writeScript "rules" ''
    #!${pkgs.stdenv.shell}

    wid=$1
    class=$2

    if [[ "''${class}" =~  ^jetbrains-.*$ ]] && [[ "$(${pkgs.xtitle}/bin/xtitle "''${wid}")" =~ ^win[0-9]*$ ]] ; then
      echo "manage=off"
      exit 0
    fi

    if [[ "''${class}" =~ ^Peek ]] ; then
      echo "manage=off"
      exit 0
    fi

    #if [[ "''${class}" =~ ^Ibus-ui-* ]] ; then
    #  echo "manage=off"
    #  exit 0
    #fi
  '';

  bspwmrc = pkgs.writeScript "bspwmrc" ''
    #!${pkgs.stdenv.shell}

    bspc config normal_border_color   '#F9F9F9'
    bspc config active_border_color   '#CCFF00'
    bspc config focused_border_color  '#00CCFF'
    bspc config presel_feedback_color '#FFCC33'

    bspc config top_padding 48
    bspc config left_padding 0
    bspc config bottom_padding 0
    bspc config right_padding 0
    bspc config window_gap 48
    bspc config border_width 3

    bspc monitor -d 1 2 3 4 5 6 7 8 9

    bspc config click_to_focus button1
    bspc config focus_follows_pointer true
    
    bspc config pointer_modifier mod1
    bspc config pointer_action1 move
    bspc config pointer_action2 resize_side
    bspc config pointer_action3 resize_corner
    
    bspc config external_rules_command ${bspwmRules}

    if test ! -d /run/media/nyarla/DATA ; then
      ${pkgs.glib}/bin/gio mount -d ''$(${pkgs.coreutils}/bin/readlink -e /dev/disk/by-uuid/c915d2df-c24e-4cf6-ab32-bf996ca84505)
    fi
    
    ${pkgs.hsetroot}/bin/hsetroot -full /etc/nixos/assets/wallpaper.jpg
    ${polybarLaunch} &

    ${pkgs.networkmanagerapplet}/bin/nm-applet &

    ${pkgs.gnome3.dconf}/libexec/dconf-service &
    env GDK_SCALE=1 GDK_DPI_SCALE=1 ${config.i18n.inputMethod.package}/bin/ibus-daemon -drx --config=${config.i18n.inputMethod.package}/libexec/ibus-dconf
  '';
  
  Xresources = pkgs.writeText "Xresources" ''
    Xcursor*theme: /run/current-system/sw/share/icons/capitaine-cursors-white
    Xcursor*size: 48
  '';

  sxhkdrc = pkgs.writeText "sxhkd" ''
    super + a ; c
      ${pkgs.mate.caja}/bin/caja

    super + a ; d
      ${pkgs.deadbeef}/bin/deadbeef
 
    super + a ; g
      ${pkgs.chromium}/bin/chromium

    super + a ; l
      ${pkgs.stdenv.shell} ~/local/dotfiles/scripts/rofi-application-launch.sh

    super + a ; q
      ${pkgs.gnome3.zenity}/bin/zenity --question --text "ログアウトしますか？" --no-wrap && ${pkgs.bspwm}/bin/bspc quit

    super + a ; t
      ${pkgs.mlterm}/bin/mlterm

    super + a ; x
      ${pkgs.bspwm}/bin/bspc node focused -c

    super + a ; X
      ${pkgs.bspwm}/bin/bspc node focused -k

    super + l
      ${pkgs.lightdm}/bin/dm-tool switch-to-greeter

    super + a ; {1,2,3,4,5,6,7,8,9}
      ${pkgs.bspwm}/bin/bspc desktop -f {1,2,3,4,5,6,7,8,9}

    super + a ; ctrl + c
      true

    super + shift + Left
      ${pkgs.bspwm}/bin/bspc node -s west || ${pkgs.bspwm}/bin/bspc node -s east

    super + shift + Right
      ${pkgs.bspwm}/bin/bspc node -s east || ${pkgs.bspwm}/bin/bspc node -s west

    super + shift + Up
      ${pkgs.bspwm}/bin/bspc node -s north || ${pkgs.bspwm}/bin/bspc node -s south

    super + shift + Down
      ${pkgs.bspwm}/bin/bspc node -s south || ${pkgs.bspwm}/bin/bspc node -s north

    super + ctrl + {Up,Left,Right,Down}
      ${pkgs.bspwm}/bin/bspc node -f {north,west,east,south}

    super + alt + Left
      ${pkgs.bspwm}/bin/bspc node -z right -10 0 || ${pkgs.bspwm}/bin/bspc node -z left -10 0

    super + alt + Right
      ${pkgs.bspwm}/bin/bspc node -z right 10 0 || ${pkgs.bspwm}/bin/bspc node -z left 10 0

    super + alt + Up
      ${pkgs.bspwm}/bin/bspc node -z top 0 -10 || ${pkgs.bspwm}/bin/bspc node -z bottom 0 -10

    super + alt + Down
      ${pkgs.bspwm}/bin/bspc node -z top 0 10 || ${pkgs.bspwm}/bin/bspc node -z bottom 0 10

    super + {Left,Right}
      ${pkgs.bspwm}/bin/bspc desktop -f {prev,next}

    XF86AudioRaiseVolume
      ${config.hardware.pulseaudio.package}/bin/pactl set-sink-mute 1 false ; ${config.hardware.pulseaudio.package}/bin/pactl set-sink-volume 1 +1%

    XF86AudioLowerVolume
      ${config.hardware.pulseaudio.package}/bin/pactl set-sink-mute 1 false ; ${config.hardware.pulseaudio.package}/bin/pactl set-sink-volume 1 -1%

    XF86AudioMute
      ${config.hardware.pulseaudio.package}/bin/pactl set-sink-mute 1 toggle

    XF86MonBrightnessDown
      ${pkgs.light}/bin/light -U 10% 

    XF86MonBrightnessUp
      ${pkgs.light}/bin/light -A 10%
  '';
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;

  systemd.packages = with pkgs; [
    dunst
  ];
  
  services.compton = {
    enable        = true;
    backend       = "glx";

    shadow        = true;
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = "0.2";
    shadowExclude = [
      "class_g = 'Firefox' && argb"
    ];

    fade          = true;
    fadeDelta     = 10;
    fadeSteps     = [ "0.25" "0.25" ];

    vSync         = true;

    settings      = {
      "shadow-radius" = 15;
    };
  };
  
  services.xserver = {
    enable                = true;
    autorun               = true;
    updateDbusEnvironment = true;
    libinput.enable       = true;

    displayManager        = {
      job.environment.LANG = "ja_JP.UTF-8";
      defaultSession = "bspwm";
      lightdm     = {
        enable    = true;
        greeters  = {
          mini = {
            enable      = true;
            user        = "nyarla";
            extraConfig = ''
              [greeter]
              show-password-label   = true
              show-input-cursor     = true
              password-label-text   = login:

              [greeter-hotkeys]
              mod-key       = control
              shutdown-key  = s
              suspend-key   = p
              hibernate-key = h
              restart-key   = r

              [greeter-theme]
              font              = "Sans"
              font-size         = 1em
              text-color        = "#F9F9F9"
              error-color       = "#FF0000"
              background-image  = ""
              background-color  = "#333333"
              window-color      = "#333333"
              border-color      = "#00CCFF"
              border-width      = 1px
              layout-space      = 30
              password-color            = "#FFFFFF"
              password-background-color = "#333333"
            '';
          }; 
        };
      };
    };

    desktopManager = {
      session = pkgs.stdenv.lib.singleton {
        name  = "bspwm";
        start = ''
          export GTK_DATA_PREFIX=${config.system.path}
          export NIX_GSETTINGS_OVERRIDES_DIR=${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
          export CAJA_EXTENSION_DIRS=$CAJA_EXTENSION_DIRS''${CAJA_EXTENSION_DIRS:+:}${config.system.path}/lib/caja/extensions-2.0/

          ${pkgs.stdenv.lib.concatMapStrings (p: ''
            ${addToXDGDirs p}
          '') config.environment.systemPackages}

          export XCURSOR_THEME=capitaine-cursors-white
          export XCURSOR_SIZE=48

          ${pkgs.xorg.xrdb}/bin/xrdb -merge ${Xresources}
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
          export SXHKD_SHELL=${pkgs.zsh}/bin/zsh
          ${pkgs.sxhkd}/bin/sxhkd -c ${sxhkdrc}  &
          ${pkgs.bspwm}/bin/bspwm -c ${bspwmrc} &
          waitPID=$!
        '';
      };
    };
  };
}
