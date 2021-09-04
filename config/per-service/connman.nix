{ config, pkgs, ... }:
let
  apps = if config.services.xserver.enable then
    (with pkgs; [ connman-gtk ])
  else
    [ ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;

  services.connman = {
    enable = true;
    enableVPN = true;
    package = pkgs.connmanFull;
    wifi.backend = "iwd";
    networkInterfaceBlacklist = [ "vnet0" "tailscale0" "docker0" ];
    extraConfig = ''
      EnableOnlineCheck=false
    '';
  };
}
