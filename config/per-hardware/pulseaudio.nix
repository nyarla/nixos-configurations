{ config, pkgs, ... }:
{
  hardware.pulseaudio = {
    enable        = true;
    support32Bit  = true;
    package       = pkgs.pulseaudioFull;
    daemon.config = {
      flat-volumes = "no";
      default-sample-rate = "96000";
    };
  };
  
  nixpkgs.config.pulseaudio = true;
}
