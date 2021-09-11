{ pkgs, ... }:
let sync = with pkgs; [ syncthing ];
in {
  imports = [
    ../per-service/avahi.nix
    ../per-service/connman.nix
    ../per-service/docker.nix
    ../per-service/firewall.nix
    ../per-service/kvm.nix
    ../per-service/tailscale.nix
  ];

  environment.systemPackages = sync;
  services.dbus.packages = sync;

  services.avahi.interfaces = [ "wlp5s0" ];

  networking.firewall.interfaces = {
    "tailscale0" = {
      allowedTCPPorts = [
        # calibre-server
        8085
      ];
    };
    "wlan0" = {
      allowedTCPPorts = [
        # syncthing
        22000
      ];
      allowedUDPPorts = [
        # service
        22000
        21027
      ];
    };
  };

}
