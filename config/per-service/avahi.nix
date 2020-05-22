{ config, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    interfaces = [ "wlp2s0" ];
    ipv4 = true;
    ipv6 = false;
    reflector = true;
    nssmdns = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
      domain = true;
    };
  };
}
