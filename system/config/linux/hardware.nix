{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pciutils
    smartmontools
    usbutils
  ];
}
