{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ mosh ];

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "no";
    startWhenNeeded = true;
    listenAddresses = [
      {
        addr = "0.0.0.0";
        port = 2222;
      }
    ];
  };
}
