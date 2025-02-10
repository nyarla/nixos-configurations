{ pkgs, ... }:
{
  home.packages = with pkgs; [
    winetricks
    wine-staging-run
    wine-vst-run
  ];
}
