{ config, pkgs, ... }:
{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 17500 ];
  networking.firewall.allowedUDPPorts = [ 17500 ];
}
