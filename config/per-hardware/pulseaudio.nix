{ config, pkgs, ... }:
{
  hardware.pulseaudio = {
    enable        = true;
    support32Bit  = true;
    package       = pkgs.pulseaudioFull;
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


  # nixpkgs.config.pulseaudio = true;
}
