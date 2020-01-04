{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vimHugeX
    editorconfig-core-c 
  ];

  services.dbus.packages = with pkgs; [
    vimHugeX
  ];
}
