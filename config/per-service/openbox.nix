{ config, pkgs, ... }:
let
  apps = (with pkgs; [
    hsetroot
    i3lock-fancy
    jq
    lxappearance
    lxqt.lxqt-config
    lxqt.lxqt-panel
    maim
    mate.mate-system-monitor
    mlterm
    obconf
    openbox
    perl
    sxhkd
    wmctrl
    xdotool
  ]) ++ pkgs.lxqt.preRequisitePackages;
in {
  imports = [
    ./fonts.nix
    ./theme.nix
    ./gnome-compatible.nix
    ./gsettings.nix
    ./picom.nix
    ./xorg.nix
  ];

  environment.systemPackages = apps;

  services.xserver.displayManager.defaultSession = "openbox";
  services.xserver.desktopManager.session = pkgs.lib.singleton {
    name = "openbox";
    start = ''
      for rc in $(ls /etc/profile.d); do
        . /etc/profile.d/$rc
      done

      export LANG=ja_JP.UTF-8
      export LC_ALL=ja_JP.UTF-8

      if test -z "''${$DBUS_SESSION_BUS_ADDRESS}"; then
        eval "$(dbus-launch --exit-with-session --sh-syntax)"
      fi

      systemctl --user import-environment DISPLAY XAUTHORITY

      if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
      fi

      ${pkgs.sxhkd}/bin/sxhkd -c /etc/nixos/dotfiles/openbox/sxhkdrc &
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursur_name left_ptr
      ${pkgs.openbox}/bin/openbox-session
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";
}