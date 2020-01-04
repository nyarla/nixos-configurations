{ config, pkgs, ... }:
{
  hardware.pulseaudio = {
    enable        = true;
    support32Bit  = true;
    package       = pkgs.pulseaudioFull;
    daemon.config = {
      flat-volumes = "no";
    };
  };
  
  nixpkgs.config.pulseaudio = true;
}
