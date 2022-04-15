{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
    wifi = {
      backend = "iwd";
      powersave = false;
    };
    unmanaged = [ "docker0" "virbr0" "tailscale0" ];
  };
}
