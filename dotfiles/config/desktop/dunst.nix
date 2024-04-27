{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    iconTheme = {
      name = "Fluent";
      package = pkgs.flatery-icon-theme;
      size = "16x16";
    };
    waylandDisplay = "wayland-0";
    settings = {
      global = {
        width = 240;
        hight = 135;
        offset = "48x24";
        progress_bar_hight = 3;
        progress_bar_min_width = 60;
        progress_bar_max_widthi = 120;
        separator_height = 16;
        padding = 4;
        horizontal_padding = 8;
        text_icon_padding = 8;
        font = "Noto Sans CJK JP 8";
        light_height = 11;
        icon_position = "left";
        min_icon_size = 16;
        max_icon_size = 16;
        frame_width = 1;

        vertical_alignment = "top";
        alignment = "left";
        format = ''
          <b>%a</b>
          %s
          %b
        '';

        background = "#F9F9F9";
        foreground = "#000000";
        highlight = "#666666";
        frame_color = "#000000";
      };

      urgency_low = {
        background = "#00CCFF";
        foreground = "#000000";
      };
      urgency_normal = {
        background = "#FFCC33";
        foreground = "#000000";
      };
      uergency_critical = {
        background = "#FF6633";
        foreground = "#000000";
      };
    };
  };
}
