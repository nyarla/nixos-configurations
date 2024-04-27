{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineUsingFull
    winetricks
    wine-run
  ];
}
