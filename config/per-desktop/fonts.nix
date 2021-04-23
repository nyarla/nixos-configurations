{ config, pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      # basical fonts
      noto-fonts
      # noto-fonts-jp
      noto-fonts-extra
      noto-fonts-emoji

      # monospace
      myrica
      nerdfonts-symbols

      # documenation
      genjyuu-gothic
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "MyricaM M" "Noto Color Emoji" "Symbols Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };
}
