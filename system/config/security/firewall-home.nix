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
          # immsered-vr
          21000

          # syncthing
          22000
        ];

        allowedUDPPorts = [
          # immsered-vr
          21000
          21010

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
