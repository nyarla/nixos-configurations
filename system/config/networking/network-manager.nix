{ pkgs, ... }: {
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
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
