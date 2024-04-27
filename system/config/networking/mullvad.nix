{ config, pkgs, ... }:
let
  apps = with pkgs; [
    mullvad-vpn
    wireguard-tools
  ];
in
{
  environment.systemPackages = apps;

  networking.firewall.allowedUDPPorts = [ 51820 ];

  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  boot.kernelModules = [
    "wireguard"
    "tun"
  ];

  systemd.services.mullvad-vpn = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network.target" ];
    after = [
      "network-online.target"
      "systemd-resolved.service"
    ];
    path = [
      pkgs.iproute
      # Needed for ping
      "/run/wrappers"
    ];
    serviceConfig = {
      StartLimitBurst = 5;
      StartLimitIntervalSec = 20;
      ExecStart = "${pkgs.mullvad-vpn}/bin/mullvad-daemon -v --disable-stdout-timestamps";
      Restart = "always";
      RestartSec = 1;
    };
  };
}
