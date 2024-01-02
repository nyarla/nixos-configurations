{ pkgs, ... }: {
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
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
        monospace = [ "HackGen Console" "Hack Nerd Font" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
