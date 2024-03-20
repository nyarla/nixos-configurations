{ color, pkgs }:
let
  config = {
    # terminal
    use_login_shell = true;
    termtype = "mlterm-256color";
    encoding = "UTF-8";
    col_size_of_width_a = 2;
    bidi_mode = "left";

    # font
    fontsize = 16;
    line_space = 0;
    use_anti_alias = true;
    box_drawing_font = "unicode";
    type_engine = "cairo";
    unicode_half_width_areas = "U+2500-25FF";
    unicode_full_width_areas = "U+E000-F8FF";

    # appearance
    scrollbar_mode = false;
    vt_color_mode = true;
    blink_cursor = true;

    bg_color = color.black;
    fg_color = color.hl_white;

    cursor_bg_color = color.hl_green;
    cursor_fg_color = color.black;

    tab_size = 2;
    log_size = 4096;

    # others
    mod_meta_key = "alt";
    mod_meta_mode = "esc";
    use_clipboard = true;
  };

  extraConfig = {
    x86_64-linux = {
      use_xim = false;
      input_method = "ibus";
    };
  };
in config // extraConfig."${pkgs.stdenv.system}"
