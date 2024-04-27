{ pkgs, lib, ... }:
{
  services.picom = {
    enable = true;
    package = pkgs.picom-next;

    shadow = true;
    shadowOffsets = [
      (-15)
      (-15)
    ];
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
    fadeSteps = [
      0.25
      0.25
    ];

    vSync = true;

    settings = {
      shadow-radius = 15;
      unredir-if-possible = false;
    };
  };

  systemd.user.services.picom.Install = lib.mkForce { };
}
