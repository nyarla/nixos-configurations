{ config, pkgs, ... }:
let
  utils = if config.services.xserver.enable then
    (with pkgs; [ pavucontrol ])
  else
    [ ];
in {
  environment.systemPackages = utils;
  services.dbus.packages = utils;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    daemon.config = {
      default-sample-format = "s24le";
      default-sample-rate = 192000;
      alternate-sample-rate = 176000;
      default-sample-channels = 2;
      default-channel-map = "front-left,front-right";
      resample-method = "speex-float-10";
      enable-lfe-remixing = "no";
      high-priority = "yes";
      flat-volumes = "no";
    };
  };
}
