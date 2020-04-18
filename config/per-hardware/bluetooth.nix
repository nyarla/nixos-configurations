{ config, pkgs, ... }:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.package = pkgs.bluezFull;  
  hardware.bluetooth.config = {
    Geeneral = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
}
