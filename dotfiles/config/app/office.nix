{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gucharmap
    inkscape
    libreoffice-fresh
    mate.mate-calc
    peek
    pixelorama
    simple-scan
    spice-up
  ];
}
