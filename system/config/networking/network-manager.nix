{ pkgs, lib, ... }: {
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };
  networking.networkmanager = {
    enable = true;
    # workaround for some plugin build failed
    plugins = lib.mkForce (with pkgs; [
      #networkmanager-fortisslvpn
      #networkmanager-sstp
      networkmanager-iodine
      networkmanager-l2tp
      networkmanager-openconnect
      networkmanager-openvpn
      networkmanager-vpnc
    ]);
    wifi = {
      backend = "wpa_supplicant";
      powersave = false;
    };
    unmanaged = [ "docker0" "virbr0" "tailscale0" "waydroid0" ];
  };

  networking.enableIPv6 = true;
}
