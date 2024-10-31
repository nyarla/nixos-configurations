{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    (deadbeef-with-plugins.override { plugins = [ deadbeef-fb ]; })
    glib.out
    picard
    easytag

    stability-matrix
  ];
}
