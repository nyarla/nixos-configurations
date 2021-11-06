{ config, pkgs, ... }:
let
  utils = if config.services.xserver.enable then
    (with pkgs; [ pavucontrol ])
  else
    [ ];
in {
  environment.systemPackages = utils;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    daemon.config = {
      avoid-resampling = "yes";
      alternate-sample-rate = 192000;
      default-channel-map = "front-left,front-right";
      default-fragments = 2;
      default-sample-channels = 2;
      default-sample-format = "s32le";
      default-sample-rate = 192000;
      flat-volumes = "no";
      high-priority = "yes";
      resample-method = "soxr-vhq";
    };
    extraConfig = ''
      load-module module-null-sink sink_name=44100Hz sink_properties=device.description=44100Hz format=s16le rate=44100 channels=2 formats=pcm
      load-module module-null-sink sink_name=96000Hz sink_properties=device.description=96000Hz format=s24le rate=96000 channels=2 formats=pcm

      load-module module-loopback source=44100Hz source_dont_move=true adjust_time=0 latency_msec=1 remix=false
      load-module module-loopback source=96000Hz source_dont_move=true adjust_time=0 latency_msec=1 remix=false
    '';
  };
}
