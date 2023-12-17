_: {
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = "loose"; # for tailscale
    interfaces = {
      "tailscale0" = {
        allowedTCPPorts = [
          # calibre
          8085

          # http
          80
          443
          1313 # for development

          # ssh
          22
        ];

        allowedUDPPortRanges = [{
          # mosh
          from = 60000;
          to = 61000;
        }];
      };

      "wlan0" = {
        allowedTCPPorts = [
          # syncthing
          22000
        ];

        allowedUDPPorts = [
          # scanner
          8610
          8612

          # syncthing
          22000
          21027
        ];
      };

      "vboxnet0" = {
        allowedTCPPorts = [
          # NetBIOS
          137
          138
          139
          445
        ];

        allowedUDPPorts = [
          # NetBIOS
          137
          138
          139
          445

          # netjack
          19000
        ];
      };
    };
  };
}
