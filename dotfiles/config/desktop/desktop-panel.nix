{ pkgs, config, ... }:
{
  xdg.configFile."waybar/style.css".text = ''
    * image {
      -GtkWidget-vexpand: true;
    }

    #tray {
      padding-right: 4px;
    }
  '';

  xdg.configFile."waybar/config".text = builtins.toJSON {
    position = "top";
    height = 28;
    modules-left = [
      "custom/app"
      "custom/creative"
      "wlr/taskbar"
    ];
    modules-right = [
      "tray"
      "clock"
    ];

    "custom/app" = {
      format = "  ";
      on-click-release = "ydotool key 56:1 59:1 59:0 56:0";
    };

    "custom/creative" = {
      format = "  ";
      on-click-release = "ydotool key 56:1 60:1 60:0 56:0";
    };

    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 16;
      icon-theme = "Fluent";
      tooltip-format = "{title}";
      on-click = "minimize-raise";
      on-click-middle = "close";
    };

    "tray" = {
      icon-size = 16;
      spacing = 6;
    };

    "clock" = {
      interval = 1;
      format = "<b>{:L%F %T（%a）}</b>";
      timezone = "Asia/Tokyo";
      locale = "ja_JP.UTF-8";
      on-click-release = "env GDK_BACKEND=x11 galendae -c /home/nyarla/.config/galendae/config";
    };
  };

  xdg.configFile."galendae/config".text = ''
    stick=0
    undecorated=1
    close_on_unfocus=0
    position=none

    background_color=#F5F6F7
    foreground_color=#5C616C
    fringe_date_color=#000000
    highlight_color=#000000

    month_font_size=100%
    month_font_weight=normal

    week_start=0

    y_offset=24
    x_offset=1648
  '';
}
