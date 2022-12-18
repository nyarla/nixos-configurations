{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg-utils libnotify sx ];
in {
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
}
