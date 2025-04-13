{ ... }:
{
  programs.weylus = {
    enable = true;
    users = [ "nyarla" ];
  };

  networking.firewall.interfaces.wlan0.allowedTCPPorts = [
    1701
    9001
  ];
}
