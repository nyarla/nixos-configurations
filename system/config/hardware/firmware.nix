{ pkgs, ... }:
{
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;
  environment.systemPackages = with pkgs; [ gnome-firmware ];
  services.dbus.packages = with pkgs; [ gnome-firmware ];
}
