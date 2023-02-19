{ pkgs, ... }: {
  home.packages = with pkgs; [
    calibre
    foliate
    glib.out
    jack2
    picard
    qjackctl
    tenacity
  ];
}
