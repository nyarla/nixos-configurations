{ config, pkgs, ... }:
let
  apps = if config.services.xserver.enable then
    (with pkgs; [ connman-gtk ])
  else
    [ ];
in {
  environment.systemPackages = apps;

  networking.wireless.iwd.enable = true;
  services.connman = {
    enable = true;
    enableVPN = true;
    package = pkgs.connmanFull;
    wifi.backend = "iwd";
    networkInterfaceBlacklist = [ "vnet" "tailscale" "docker" ];
    extraConfig = ''
      EnableOnlineCheck=false
    '';
  };
}
