{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
  networking.networkmanager = {
    enable = true;
    dhcp = "internal";
    wifi = {
      backend = "wpa_supplicant";
      powersave = false;
    };
    unmanaged = [
      "interface-name:tailscale*"
      "interface-name:vboxnet*"
      "interface-name:virbr*"
      "interface-name:waydroid*"
      "type:bridge"
    ];
  };

  networking.enableIPv6 = true;
}
