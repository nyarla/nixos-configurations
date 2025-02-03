{ pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [ gnome-firmware ];
}
