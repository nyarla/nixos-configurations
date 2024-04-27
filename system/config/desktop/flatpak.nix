{ pkgs, ... }:
{
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [ gnome.gnome-software ];
}
