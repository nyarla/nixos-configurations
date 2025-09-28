{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    (deadbeef-with-plugins.override { plugins = [ deadbeef-fb ]; })
    easytag
    glib.out
    picard
    thorium-reader
    vlc
  ];
}
