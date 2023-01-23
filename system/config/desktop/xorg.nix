{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg-utils libnotify sx ];
in {
  imports = [ ./gnome-compatible.nix ];

  environment.systemPackages = utils;
  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;
    exportConfiguration = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      defaultSession = "none+openbox";
      lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "nyarla";
        };
        extraSeatDefaults = ''
          user-session = ${config.services.xserver.displayManager.defaultSession}
        '';
      };
    };

    windowManager.openbox.enable = true;
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
      "override_redirect = true"
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
