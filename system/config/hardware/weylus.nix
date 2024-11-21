{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    weylus
  ];

  networking.firewall.interfaces.wlan0.allowedTCPPorts = [
    1701
    9001
  ];
}
