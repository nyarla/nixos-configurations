{ pkgs, ... }:
{
  home.packages = with pkgs; [
    winetricks
    wine-staging-run
  ];
}
