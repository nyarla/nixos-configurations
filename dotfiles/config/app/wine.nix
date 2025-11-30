{ pkgs, ... }:
{
  home.packages = with pkgs; [
    carla-with-wine
    wine-staging-run
    wine-vst-run
    winetricks
  ];
}
