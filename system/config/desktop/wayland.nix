{ pkgs, ... }:
{
  imports = [ ./gnome-compatible.nix ];
  security.pam.services.swaylock = { };
  services.dbus.packages = with pkgs; [
    xembed-sni-proxy
    waybar
  ];
  environment.systemPackages = with pkgs; [
    xembed-sni-proxy
    waybar
  ];
}
