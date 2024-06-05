{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    multipath-tools
    pciutils
    usbutils
  ];
}
