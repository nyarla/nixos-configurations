_: {
  # mtu
  networking.interfaces."wlan0".mtu = 1472;

  # avahi
  services.avahi.allowInterfaces = [ "wlan0" ];
}
