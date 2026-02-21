{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gucharmap
    libreoffice
    mate-calc
    simple-scan
  ];
}
