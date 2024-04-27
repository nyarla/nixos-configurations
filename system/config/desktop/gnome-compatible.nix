{ config, pkgs, ... }:
let
  gnomeApps =
    (with pkgs.gnome; [
      zenity
      dconf-editor
    ])
    ++ (with pkgs; [
      gsound
      gcr
    ]);
in
{
  environment.systemPackages = gnomeApps;

  services = {
    accounts-daemon.enable = true;
    dbus.enable = true;
    dbus.packages = gnomeApps;
    system-config-printer.enable = true;

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
  };

  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  services.upower.enable = config.powerManagement.enable;
}
