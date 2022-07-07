{ pkgs, lib, ... }:
let
  sxhkdrc = pkgs.writeText "sxhkdrc" ''
    super + l
      xset dpms force off

    super + alt + l
      ${pkgs.mlterm}/bin/mlterm
  '';

  sxrc = pkgs.writeShellScript "xinitrc" ''
    for rc in $(ls /etc/profile.d); do
      . /etc/profile.d/$rc
    done

    for rc in $(ls $HOME/.config/profile.d); do
      . $HOME/.config/profile.d/$rc
    done

    export XDG_SESSION_TYPE=x11

    systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS XDG_SESSION_ID
    systemctl --user start graphical-session.target

    sxhkd -c ${sxhkdrc} &
    xrandr --output HDMI-0 --primary
    xsetroot -cursor_name left_ptr

    openbox-session &
    waitPID=$!

    dbus-update-activation-environment --systemd --all

    test -n "$waitPID" && wait "$waitPID"

    systemctl --user stop graphical-session.target

    exit 0
  '';

in {
  home.packages = with pkgs;
    [
      capitaine-cursors
      flatery-icon-theme
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      gtk-engine-murrine
      gtk_engines
      hicolor-icon-theme
      qgnomeplatform
      victory-gtk-theme

      libsecret
      pinentry-gnome

      clipit
      hsetroot
      i3lock-fancy
      jq
      lxappearance
      lxqt.lxqt-config
      lxqt.lxqt-panel
      maim
      mate.mate-system-monitor
      obconf
      openbox
      perl
      sxhkd
      wmctrl
      xdotool
      xsettingsd
    ] ++ lxqt.preRequisitePackages;

  xdg.configFile = {
    # openbox
    "openbox/autostart".source = toString (with pkgs;
      (import ./autostart.nix) { inherit fetchurl writeShellScript pkgs; });

    "openbox/menu.xml".text = (import ./menu.nix) { };

    "openbox/environment".source = toString (pkgs.writeScript "environment" ''
      export GTK2_RC_FILES=$HOME/.gtkrc-2.0
      export LANG=ja_JP.UTF_8
      export LC_ALL=ja_JP.UTF-8
      export QT_QPA_PLATFORMTHEME=gnome
    '');

    "openbox/rc.xml".text = (import ./rc.nix) { inherit lib; };

    # sx
    "sx/sxrc".source = "${sxrc}";

  };
}
