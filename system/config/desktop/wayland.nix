{ pkgs, ... }:
{
  security.pam.services.swaylock = { };
  services.dbus.packages = with pkgs; [
    xembed-sni-proxy
  ];
  environment.systemPackages = with pkgs; [
    xembed-sni-proxy
  ];
}
