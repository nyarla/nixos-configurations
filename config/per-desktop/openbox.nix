{ config, pkgs, ... }:
let apps = with pkgs; [ openbox sxhkd wmctrl mlterm hsetroot perl ];
in {
  imports = [
    ../per-desktop/fonts.nix
    ../per-desktop/theme.nix
    ../per-service/gnome-compatible.nix
    ../per-service/gsettings.nix
    ../per-service/picom.nix
    ../per-service/xorg.nix
  ];

  environment.systemPackages = apps;
  services.dbus.packages = apps;
  #systemd.packages = with pkgs; [ dunst ];

  services.xserver.displayManager.defaultSession = "openbox";
  services.xserver.desktopManager.session = pkgs.lib.singleton {
    name = "openbox";
    start = ''
      for rc in $(ls /etc/profile.d); do
        . /etc/profile.d/$rc
      done

      ${pkgs.sxhkd}/bin/sxhkd -c /etc/nixos/dotfiles/openbox/sxhkdrc &

      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursur_name left_ptr
      ${pkgs.openbox}/bin/openbox-session
    '';
  };

  i18n.defaultLocale = "ja_JP.UTF-8";
}
