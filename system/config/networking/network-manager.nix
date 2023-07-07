_: {
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    wifi = {
      backend = "iwd";
      powersave = false;
    };
    unmanaged = [ "docker0" "virbr0" "tailscale0" "waydroid0" ];
  };

  networking.enableIPv6 = true;
}
