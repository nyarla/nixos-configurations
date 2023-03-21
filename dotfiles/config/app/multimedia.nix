{ pkgs, ... }: {
  home.packages = with pkgs; [
    calibre
    deadbeef
    foliate
    glib.out
    jack2
    picard
    qjackctl
    tenacity
  ];
}
