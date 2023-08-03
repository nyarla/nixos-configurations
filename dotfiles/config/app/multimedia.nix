{ pkgs, ... }: {
  home.packages = with pkgs; [ audacity calibre deadbeef glib.out picard ];
}
