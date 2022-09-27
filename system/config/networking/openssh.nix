_: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    permitRootLogin = "no";
    openFirewall = false;
    passwordAuthentication = true;
    kbdInteractiveAuthentication = false;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 2222;
    }];
  };
}
