{ config, pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      # basical fonts
      noto-fonts
      noto-fonts-jp
      noto-fonts-extra
      twemoji-color-font

      # monospace
      myrica
      nerdfont-symbols-2048

      # fallback
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;

      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="family">
                  <string>Noto Color Emoji</string>
                </patelt>
              </pattern>
              <pattern>
                <patelt name="family">
                  <string>Noto Emoji</string>
                </patelt>
              </pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';

      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
        monospace = [ "MyricaM M" "Symbols Nerd Font" "DejaVu Sans" ];
        emoji = [ "Twitter Color Emoji" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };
}
