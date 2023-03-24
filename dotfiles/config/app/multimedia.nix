{ pkgs, ... }: {
  home.packages = with pkgs; [
    calibre
    deadbeef
    foliate
    glib.out
    picard
    tenacity
  ];
}
