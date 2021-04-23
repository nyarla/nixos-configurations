{ config, pkgs, ... }:
let
  ipv4 = "169.254.229.129";
  app = with pkgs; [ mlterm xclip syncthing xorg.xauth ];
in {
  imports = [
    ../per-desktop/fonts.nix
    ../per-desktop/ibus.nix
    ../per-service/gsettings.nix
  ];

  environment.systemPackages = app;
  services.dbus.packages = app;

  i18n.defaultLocale = "en_US.UTF-8";

  networking.enableIPv6 = false;
  networking.interfaces.eth1 = {
    ipv4.addresses = [{
      address = ipv4;
      prefixLength = 16;
    }];
  };

  networking.firewall = { enable = false; };

  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    forwardX11 = true;
    listenAddresses = [{
      addr = ipv4;
      port = 22;
    }];
  };

  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "dummy" ];
  };

  boot.kernel.sysctl = { "fs.inotify.max_user_watches" = "204800"; };

  systemd.extraConfig = ''
    DefaultLimitCORE=infinity
    DefaultLimitNOFILE=infinity
    DefaultLimitSTACK=infinity
  '';
}
