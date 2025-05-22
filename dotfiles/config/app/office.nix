{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gucharmap
    libreoffice
    mate.mate-calc
    simple-scan
  ];
}
