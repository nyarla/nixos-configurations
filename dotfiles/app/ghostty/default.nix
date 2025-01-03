{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile."ghostty/config".text = ''
    theme = kalaclista

    font-family = Mononspace
    font-size = 12
    font-feature = -dlig

    grapheme-width-method = legacy

    cursor-style = block
    cursor-style-blink = true

    keybind = ctrl+p=paste_from_clipboard

    gtk-single-instance = true
    gtk-tabs-location = bottom
    gtk-adwaita = false
  '';

  xdg.configFile."ghostty/themes/kalaclista".text = ''
    palette = 0=#111111
    palette = 1=#f77468
    palette = 2=#aee46f
    palette = 3=#ffcb61
    palette = 4=#8cc8ff
    palette = 5=#fb7fd5
    palette = 6=#00efff
    palette = 7=#f1f1f1
    palette = 8=#9e9e9e
    palette = 9=#ff8274
    palette = 10=#bcf27c
    palette = 11=#ffd96e
    palette = 12=#abe4ff
    palette = 13=#ffb7ff
    palette = 14=#00ffff
    palette = 15=#ffffff

    background = 111111
    foreground = ffffff

    cursor-color = bcf27c 

    selection-background = abe4ff
    selection-foreground = 000000
  '';
}
