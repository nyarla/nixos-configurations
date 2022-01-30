{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lsof
    htop
    pciutils
    usbutils
    multipath-tools
  ];
}
