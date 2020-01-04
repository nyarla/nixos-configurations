{ config, pkgs, ... }:
{
  programs.dconf.enable = true;
  services.accounts-daemon.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  services.gnome3.gnome-settings-daemon.enable = true;
  services.system-config-printer.enable = true;
  services.upower.enable = config.powerManagement.enable;
  services.dbus.socketActivated = true;
  environment.pathsToLink = [ "/share" ];
  environment.systemPackages = with pkgs; [ gtk3 ];
}
