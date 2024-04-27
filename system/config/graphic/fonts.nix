{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # basical fonts
      noto-fonts
      noto-fonts-jp
      noto-fonts-extra
      noto-fonts-emoji

      # monospace
      hackgen-font
      (nerdfonts.override { fonts = [ "Hack" ]; })

      # fallback
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK JP"
          "DejaVu Sans"
          "Noto Sans Symbols"
          "Noto Sans Symbols2"
        ];
        serif = [
          "Noto Serif JP"
          "DejaVu Serif"
          "Noto Sans Symbols"
          "Noto Sans Symbols2"
        ];
        monospace = [
          "HackGen Console"
          "Hack Nerd Font"
          "DejaVu Sans Mono"
          "Noto Sans Symbols"
          "Noto Sans Symbols2"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
