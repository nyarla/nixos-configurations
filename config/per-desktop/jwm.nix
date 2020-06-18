{ config, pkgs, ... }:
let
  apps = with pkgs; [
    polybarFull
    dunst
    rofi
    sxhkd
    jwm
    jwm-settings-manager
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

  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides"
    { }
    ''
      mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
      cp -rf ${pkgs.gnome3.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml \
        $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

      ${pkgs.stdenv.lib.concatMapStrings
        (p: ''
          if test -d ${p}/share/gsettings-schemas; then
            cp -rf ${p}/share/gsettings-schemas/*/glib-2.0/schemas/* \
              $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
          fi
        '')
        (config.environment.systemPackages ++ [ config.i18n.inputMethod.package ] ++ apps)}

      ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';
  Xresources = pkgs.writeText "Xresources" ''
    Xcursor*theme: /run/current-system/sw/share/icons/capitaine-cursors-white
    Xcursor*size: 48
  '';
in
{
  environment.systemPackages = apps;
  services.dbus.packages = apps;
  systemd.packages = with pkgs; [
    dunst
  ];

  services.compton = {
    enable = true;
    backend = "glx";

    shadow = true;
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = 0.2;
    shadowExclude = [
      "class_g = 'Firefox' && argb"
    ];

    fade = true;
    fadeDelta = 10;
    fadeSteps = [ 0.25 0.25 ];

    vSync = true;

    settings = {
      "shadow-radius" = 15;
    };
  };

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      defaultSession = "jwm";
      lightdm = {
        enable = true;
        greeters = {
          mini = {
            enable = true;
            user = "nyarla";
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
              password-border-color = "#00CCFF"
              password-border-width = 1px
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
        name = "jwm";
        start = ''
          export GTK_DATA_PREFIX=${config.system.path}
          export NIX_GSETTINGS_OVERRIDES_DIR=${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
          export CAJA_EXTENSION_DIRS=$CAJA_EXTENSION_DIRS''${CAJA_EXTENSION_DIRS:+:}${config.system.path}/lib/caja/extensions-2.0/

          ${pkgs.stdenv.lib.concatMapStrings
            (p: ''
              ${addToXDGDirs p}
            '') config.environment.systemPackages}

          export XCURSOR_THEME=capitaine-cursors-white
          export XCURSOR_SIZE=48

          ${pkgs.xorg.xrdb}/bin/xrdb -merge ${Xresources}
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
          export SXHKD_SHELL=${pkgs.zsh}/bin/zsh
          ${pkgs.jwm}/bin/jwm &
          waitPID=$!
        '';
      };
    };
  };
}
