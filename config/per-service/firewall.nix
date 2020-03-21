{ config, pkgs, ... }:
{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 10080 17500 ];
  networking.firewall.allowedUDPPorts = [ 17500 ];
}
