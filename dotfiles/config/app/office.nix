{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp
    gucharmap
    inkscape
    krita
    mate.mate-calc
    pixelorama
    simple-scan
  ];
}
