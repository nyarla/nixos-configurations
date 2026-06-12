{ color, pkgs }:
let
  config = {
    # terminal
    use_login_shell = true;
    termtype = "mlterm-256color";
    encoding = "UTF-8";
    col_size_of_width_a = 1;
    bidi_mode = "left";

    # font
    fontsize = 16;
    line_space = 0;
    use_anti_alias = true;
    box_drawing_font = "unicode";
    type_engine = "cairo";
    unicode_full_width_areas = "U+2030-2031,U+203B-203B,U+2121-2121,U+213B-213B,U+214F-214F,U+2160-2182,U+2318-2318,U+2325-2325,U+23ED-23EF,U+23F1-23F2,U+23F8-23FA,U+2460-24FF,U+25A0-25A1,U+25B2-25B3,U+25BC-25BD,U+25C6-25C7,U+25CB-25CB,U+25CE-25CF,U+2600-2620,U+2622-2653,U+2668-2668,U+2670-2712,U+2744-2744,U+2747-2747,U+2763-2763,U+2776-2793,U+27DD-27DE,U+27F5-27FF,U+2B33-2B33,U+3248-324F,U+E000-EDFF,U+EE0C-F8FF,U+1F000-1F02B,U+1F030-1F093,U+1F0A0-1F0F5,U+1F100-1F1E5,U+1F200-1F77F,U+1F785-1FAF8,U+F0000-10FFFD";
    emoji_path = "${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf";

    # appearance
    scrollbar_mode = false;
    vt_color_mode = true;
    blink_cursor = true;

    bg_color = color.black;
    fg_color = color.hl_white;

    cursor_bg_color = color.hl_green;
    cursor_fg_color = color.black;

    tab_size = 2;
    log_size = 100000;

    # others
    mod_meta_key = "alt";
    mod_meta_mode = "esc";
    use_clipboard = true;
  };

  extraConfig = {
    x86_64-linux = {
      use_xim = false;
      input_method = "fcitx";
    };
  };
in
config // extraConfig."${pkgs.stdenv.system}"
