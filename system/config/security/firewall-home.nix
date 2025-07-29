_: {
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = "loose"; # for tailscale
    trustedInterfaces = [
      "virbr0"
    ];
    interfaces = {
      "lo" = {
        allowedTCPPorts = [
          9757
        ];
        allowedUDPPorts = [
          5353
          9757
        ];
      };

      "tailscale0" = {
        allowedTCPPorts = [
          # calibre
          8085

          # http
          80
          443
          1313 # for development
          8191 # for flaresolverr

          # ssh
          22
        ];

        allowedUDPPorts = [
          # http
          80
          443
        ];
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

      "virbr0" = {
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
