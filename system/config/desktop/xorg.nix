{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg-utils libnotify sx ];
in {
  imports = [ ./gnome-compatible.nix ];

  environment.systemPackages = utils;
  console.useXkbConfig = true;

  systemd.services.displayManagerCompat = {
    enable = true;
    wants = [ "accounts-daemon.service" ];
    requires = [ "user.slice" ];
    after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "user.slice"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true";
      BusName = "org.freedesktop.DisplayManager";
      IgnoreSIGPIPE = "no";
      KeyringMode = "shared";
      KillMode = "mixed";
      StandardError = "inherit";
    };
  };

  services.xserver = {
    enable = true;
    autorun = false;
    libinput.enable = true;
    exportConfiguration = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      lightdm = { enable = false; };
    };
  };

  services.picom = {
    enable = true;

    shadow = true;
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = 0.2;
    shadowExclude = [
      "class_g = 'firefox' && argb"
      "class_g = 'Thunderbird' && argb"
      "class_g %= '*.exe' && argb"
      "class_g %= '*.exe.*' && argb"
    ];

    fade = true;
    fadeDelta = 5;
    fadeSteps = [ 0.25 0.25 ];

    vSync = true;

    settings = {
      shadow-radius = 15;
      unredir-if-possible = false;
    };
  };
}
