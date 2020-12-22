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
      (nerdfonts.override { fonts = [ "Noto" ]; })

      # documenation
      genjyuu-gothic
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans JP" ];
        serif = [ "Noto Serif JP" ];
        monospace = [ "MyricaM M" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
