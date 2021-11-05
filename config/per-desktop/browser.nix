{ config, pkgs, ... }:
let
  apps = with pkgs; [
    bitwarden
    firefox-bin
    google-chrome
    keepassxc
    libsecret
    pinentry-gnome
    thunderbird-bin
  ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;
}
