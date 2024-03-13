{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gucharmap
    inkscape
    libreoffice-fresh
    libresprite
    mate.mate-calc
    peek
    pixelorama
    simple-scan
    spice-up
  ];
}
