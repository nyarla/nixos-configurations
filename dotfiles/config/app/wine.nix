{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wine-staging-run
    winetricks
  ];
}
