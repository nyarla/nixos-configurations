{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gucharmap
    inkscape
    libreoffice
    mate.mate-calc
    peek
    simple-scan
    spice-up
  ];
}
