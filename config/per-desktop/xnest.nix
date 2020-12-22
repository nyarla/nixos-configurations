{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ openbox obconf ];
  services.dbus.packages = with pkgs; [ openbox obconf ];
}
