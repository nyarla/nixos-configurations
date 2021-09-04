{ config, pkgs, ... }: {
  services.avahi = {
    enable = true;
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
