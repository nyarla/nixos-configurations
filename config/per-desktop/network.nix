{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ connman-gtk ];
  services.dbus.packages = with pkgs; [ connman-gtk ];
  networking.wireless = {
    enable = true;
    networks = {
      dummy = { };
    };
  };
  services.connman = {
    enable = true;
    enableVPN = true;
    package = pkgs.connmanFull;
    networkInterfaceBlacklist = [ "docker" "vboxnet" "br" ];
  };
}
