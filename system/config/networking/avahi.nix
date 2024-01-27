_: {
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    reflector = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
      domain = true;
    };
  };
}
