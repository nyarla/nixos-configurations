{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gucharmap
    mate.mate-calc
    simple-scan
  ];
}
