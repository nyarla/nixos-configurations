{ pkgs, ... }: {
  home.packages = with pkgs; [ sfwbar ];

  systemd.user.services.sfwbar = {
    Unit = {
      Description = "wayland bar services by sfwbar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.sfwbar}/bin/sfwbar";
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "LANG=ja_JP.UTF-8" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  xdg.configFile."sfwbar/sfwbar.config".text = ''
    function("SfwbarInit") {
      SetLayer "overlay"
      SetMonitor "HDMI-1"
    }

    function("ToggleMinimize") {
      [!Minimized] Minimize
      [Minimized] UnMinimize
    }

    function("ToggleMaximize") {
      [!Maximized] Maximize
      [Maximized] UnMaximize
    }

    function("ToggleRaise") {
      [Minimized] UnMinimize
      [!Minimized | !Focused] Focus
      [!Minimized | Focused] Minimize
    }

    menu("winops") {
      item("focus", Focus );
      item("close", Close );
      item("(un)minimize", Function "ToggleMinimize" );
      item("(un)maximize", Function "ToggleMaximize" );
    }

    layout {
      button "launch" {
        action = "bash -c 'ydotool mousemove 0 24; ydotool key 56:1 50:1 50:0 56:0'"
        value = "terminal"
        css = "* { min-width: 16px; min-height: 16px; margin: 0 4px; padding: 0 4px; border-radius: 3px; border-color: transparent; }"
      }

      taskbar {
        icons = true
        labels = false
        rows = 1
        action[1] = Function "ToggleRaise"
        action[3] = Menu "winops"
      }

      label {
        css = "* { -GtkWidget-hexpand: true; }"
        value = ""
      }
      
      tray {
        css = "* { min-width 16px; min-height: 16px; margin: 0px 4px; padding: 0px; }"
      }

      label {
        style = "datetime"
        interval = 1000
        value = Time("%Y-%m-%d %H:%M:%S（%a）")
      }
    }

    #CSS
    window {
      -GtkWidget-direction: top;
    }

    button#taskbar_normal image,
    button#taskbar_normal:hover image,
    button#taskbar_active image {
      min-width: 18px;
      min-height: 18px;
      padding: 2px 2px 0px 2px ;
    }

    button#taskbar_normal,
    button#taskbar_normal:hover,
    button#taskbar_active {
      margin: 0px 2px;
      padding: 0px 2px;

      background-image: none;
      
      border-image: none;
      border-radius: 3px ;
      border-color: transparent;
    }

    button#launch:hover,
    button#taskbar_normal:hover {
      background-color: #CCCCCC;
    }

    button#taskbar_active {
      border-color: #999999;
    }

    label#datetime {
      font-size: 12px;
      font-weight: bold;
      min-height: 24px;
      min-width: 160px;
      padding-left: 4px;
    }
  '';
}
