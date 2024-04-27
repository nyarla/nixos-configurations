{ pkgs, ... }:
{
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
      Environment = [
        "WAYLAND_DISPLAY=wayland-0"
        "LANG=ja_JP.UTF-8"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
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
        action = Exec "ydotool key 56:1 59:1 59:0 56:0"
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
      
      tray {}

      label {
        style = "datetime"
        interval = 1000
        value = Time("%Y-%m-%d %H:%M:%S（%a）")
        action[1] = Exec "galendae -c /home/nyarla/.config/galendae/config"
      }
    }

    #CSS

    #sfwbar {
      background-color: #F5F6F7;
      color: #000000;
      outline-width: 0px;
    }

    #sfwbar box,
    #sfwbar widget,
    #sfwbar button {
        padding-top: 0px;
        padding-bottom: 0px;
        outline-width: 0px;
    }

    #sfwbar grid{
        padding-left: 4px;
        min-width:20px;
    }

    #sfwbar button {
      min-height: 16px ;
      padding: 3px;
    }

    #sfwbar button image {
      min-width: 16px;
    }

    window {
      -GtkWidget-direction: top;
    }

    button#taskbar_normal image,
    button#taskbar_normal:hover image,
    button#taskbar_active image,
    button#tray_normal image,
    button#tray_nornal:hover image,
    button#tray_active image {
      -GtkWidget-vexpand: true;
    }

    button#taskbar_normal image,
    button#taskbar_normal:hover image,
    button#taskbar_active image {
      padding: 0px ;
    }

    button#taskbar_normal,
    button#taskbar_normal:hover,
    button#taskbar_active {
      margin: 0px;

      background-image: none;
      
      border-image: none;
      border-radius: 2px ;
      border-color: transparent;
    }

    button#tray_normal,
    button#tray_nornal:hover,
    button#tray_active {
      border: none;
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
      min-height: 16px;
      min-width: 160px;
      padding-left: 4px;
    }
  '';
}
