{ config, pkgs, ... }:
let apps = with pkgs.gnome3; [ zenity gsound dconf dconf-editor ];
in {
  environment.systemPackages = apps ++ (with pkgs; [ gtk3 ]);
  services.dbus.packages = apps;

  programs.dconf.enable = true;

  services.accounts-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  services.system-config-printer.enable = true;
  services.upower.enable = config.powerManagement.enable;
}
