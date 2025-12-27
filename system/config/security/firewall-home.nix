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

          # NetBIOS
          137
          138
          139
          445
        ];

        allowedUDPPorts = [
          # http
          80
          443

          # NetBIOS
          137
          138
          139
          445
        ];
      };

      "wlan0" = {
        allowedTCPPorts = [
          # syncthing
          22000

          # wivrn
          9757

          # steam link
          27036
          27037
        ];

        allowedUDPPorts = [
          # scanner
          8610
          8612

          # syncthing
          22000
          21027

          # wivrn
          5353
          9757

          # steam link
          10400
          10401
          27031
          27036
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
        ];
      };
    };
  };
}
