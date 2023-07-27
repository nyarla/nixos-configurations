{ pkgs, ... }: {
  services.connman.enable = true;
  services.connman.package = pkgs.connmanFull;
  services.connman.wifi.backend = "iwd";
  services.connman.networkInterfaceBlacklist =
    [ "tailscale" "docker" "veth" "virbr" ];

  environment.systemPackages = with pkgs; [ connman-gtk ];
}