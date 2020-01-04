{ config, pkgs, ... }:
{
  console.useXkbConfig = true;
  services.xserver.layout = "us";
  services.xserver.xkbModel = "pc104";
  services.xserver.xkbOptions = "ctrl:nocaps";
}
