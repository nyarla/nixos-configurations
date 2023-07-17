_: {
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
  networking.networkmanager = {
    enable = true;
    dhcp = "internal";
    wifi = {
      backend = "iwd";
      powersave = false;
    };
    unmanaged = [
      "interface-name:br-*"
      "interface-name:docker*"
      "interface-name:tailscale*"
      "interface-name:virbr*"
      "interface-name:waydroid*"
    ];
  };

  networking.enableIPv6 = true;
}
