{ config, pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [
      # basical fonts
      noto-fonts
      noto-fonts-jp
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
      penultimate.enable = true;

      defaultFonts = {
        sansSerif = [ "Noto Sans JP" "Noto Color Emoji" ];
        serif = [ "Noto Serif JP" "Noto Color Emoji" ];
        monospace = [ "MyricaM M" "Symbols Nerd Font" "Noto Color Emoji" ];
      };
    };
  };
}
