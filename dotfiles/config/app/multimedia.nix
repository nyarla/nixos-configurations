{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    deadbeef
    glib.out
    picard
    easytag
  ];
}
