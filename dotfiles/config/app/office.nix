{ pkgs, ... }: {
  home.packages = with pkgs; [
    gimp
    gnome.pomodoro
    gucharmap
    inkscape
    libreoffice
    mate.mate-calc
    peek
    simple-scan
    spice-up
  ];
}
