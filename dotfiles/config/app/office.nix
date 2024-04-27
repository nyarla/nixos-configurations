{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp
    gucharmap
    inkscape
    krita
    libreoffice-fresh
    libresprite
    mate.mate-calc
    peek
    pixelorama
    simple-scan
    spice-up
  ];
}
