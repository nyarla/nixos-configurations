{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ mosh ];

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings.kbdInteractiveAuthentication = false;
    settings.passwordAuthentication = true;
    settings.permitRootLogin = "no";
    startWhenNeeded = true;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 2222;
    }];
  };
}
