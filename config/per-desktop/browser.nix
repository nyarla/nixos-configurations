{ config, pkgs, ... }:
let
  apps = with pkgs; [
    firefox-bin
    thunderbird-bin
    google-chrome
    pinentry-gnome
    libsecret
    bitwarden
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
