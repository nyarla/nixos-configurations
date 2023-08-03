{ pkgs, lib, config, ... }:
let
  xprofile = pkgs.writeShellScript "xinitrc" ''
    for rc in $(ls /etc/profile.d); do
      . /etc/profile.d/$rc
    done

    for rc in $(ls $HOME/.config/profile.d); do
      . $HOME/.config/profile.d/$rc
    done

    xsetroot -cursor_name left_ptr
  '';

  isMe = src: if (config.home.username == "nyarla") then src else "";
  isNotMe = src: if (config.home.username != "nyarla") then src else "";
in {
  imports = [
    ../../config/desktop/1password.nix
    ../../config/desktop/blueman-applet.nix
    ../../config/desktop/calibre.nix
    ../../config/desktop/connman-gtk.nix
    ../../config/desktop/dunst.nix
    ../../config/desktop/kdeconnect.nix
    ../../config/desktop/lxqt-panel.nix
    ../../config/desktop/picom.nix
    ../../config/desktop/qt.nix
    ../../config/desktop/theme.nix
    ../../config/desktop/xorg.nix
  ];

  home.packages = with pkgs;
    [
      # terminal and development
      wezterm
      gitg

      # credential
      libsecret
      pinentry-gnome

      # clipboard
      clipit

      # utility
      hsetroot
      lxappearance

      # panel
      lxqt.lxqt-config
      lxqt.lxqt-panel

      # screen lock
      i3lock-fancy
      xss-lock

      jq
      maim
      mate.mate-system-monitor
      obconf
      openbox
      perl
      s5cmd
      sxhkd
      wmctrl
      xdotool
      xsettingsd
    ] ++ lxqt.preRequisitePackages;

  xdg.configFile = {
    # openbox
    "openbox/autostart".source = toString (with pkgs;
      (import ./autostart.nix) {
        inherit fetchurl writeShellScript pkgs isMe isNotMe;
      });

    "openbox/menu.xml".text =
      import ../../config/vars/appmenu.nix { isXorg = true; };

    "openbox/environment".source = toString (pkgs.writeScript "environment" ''
      export XCURSOR_PATH=/run/current-system/etc/profiles/per-user/nyarla/share/icons:$HOME/.icons/default
      export XCURSOR_THEME=capitaine-cursors-white
      export XCURSOR_SIZE=24

      export GTK2_RC_FILES=$HOME/.gtkrc-2.0
      export GTK_THEME=Arc

      export LANG=ja_JP.UTF_8
      export LC_ALL=ja_JP.UTF-8

      export MOZ_DISABLE_RDD_SANDBOX=1
      export NVD_BACKEND=direct
    '');

    "openbox/rc.xml".text = (import ./rc.nix) { inherit isMe isNotMe; };
  };

  home.file.".xprofile".source = toString xprofile;
}
