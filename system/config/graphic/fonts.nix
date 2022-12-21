{ pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      # basical fonts
      noto-fonts
      noto-fonts-jp
      noto-fonts-extra
      noto-fonts-emoji

      # monospace
      hackgen

      # fallback
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
        monospace = [ "HackGen Console NFJ" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
