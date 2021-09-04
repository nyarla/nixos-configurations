{ config, pkgs, ... }: {
  services.blueman.enable = config.services.xserver.enable;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  hardware.bluetooth.settings = {
    General = { Enable = "Source,Sink,Media,Socket"; };
  };
}
