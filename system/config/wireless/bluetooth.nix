{ pkgs, ... }: {
  services.blueman.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = { Enable = "Source,Sink,Media,Socket"; };
  };
}
