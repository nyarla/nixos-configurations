{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    style = ''
      #taskbar {
      }

      #taskbar button {
        padding: 1px 0px 1px 4px;
        margin: 0px 2px 0px 2px;
        border-radius: 3px 3px 3px 3px;
      }

      #custom-clock {
        margin: 0px 6px ;
      }
    '';
    settings = {
      taskbar = {
        # layer
        layer = "overlay";
        position = "top";
        mode = "dock";
        outputs = [ "HDMI-A-1" ];

        # size
        height = 24;
        spacing = 0;
        gtk-layer-shell = false;

        # widgets
        modules-left = [ "wlr/taskbar" ];
        modules-right = [ "tray" "custom/clock" ];

        # widget configurations
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 16;
          icon-theme = "Flat-Remix-Cyan-Light";
          tooltip-format = "{title}";
          on-click = "minimize-raise";
          on-click-middle = "close";
        };

        "tray" = {
          icon-size = 16;
          spacing = 2;
        };

        "custom/clock" = {
          exec = "date +'%Y-%m-%d %H:%M:%S (%a)'";
          interval = 1;
          format = "<b>{}</b>";
        };
      };
    };
  };
}
