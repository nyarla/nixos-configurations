{ config, pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      # basical fonts
      noto-fonts
      noto-fonts-jp
      noto-fonts-extra
      noto-fonts-emoji

      # monospace
      myrica
      nerdfont-symbols-2048

      # fallback
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
        monospace = [ "MyricaM M" "Symbols Nerd Font" "DejaVu Sans" ];
        emoji = [ "Noto Color Emoji" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };
}
