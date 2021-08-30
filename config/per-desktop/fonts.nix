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
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif =
          [ "Noto Sans CJK JP" "Noto Sans Symbols" "Noto Sans Symbols2" ];
        serif = [ "Noto Serif JP" "Noto Sans Symbols" "Noto Sans Symbols2" ];
        monospace = [
          "MyricaM M"
          "Symbols Nerd Font"
          "Noto Color Emoji"
          "Noto Sans Symbols"
          "Noto Sans Symbols2"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };
}
