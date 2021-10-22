{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg_utils libnotify gksu ];
in {
  environment.systemPackages = utils;
  services.dbus.packages = utils;

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      autoLogin = {
        enable = true;
        user = "nyarla";
      };
    };
  };
}
