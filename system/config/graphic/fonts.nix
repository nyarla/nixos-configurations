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
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" "Noto Color Emoji" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" "Noto Color Emoji" ];
        monospace =
          [ "HackGen Console NF" "DejaVu Sans Mono" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
