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
    ungoogled-chromium
  ];
in { environment.systemPackages = apps; }
