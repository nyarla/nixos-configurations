{ pkgs, config, ... }:
let fmt = pkgs.formats.json { };
in {
  systemd.user.services.desktop-panel = {
    Unit = {
      Description = "Autostart for Desktop Panel";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
        "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}"
        "XDG_DATA_DIRS=/run/current-system/sw/share"
      ];
      ExecStart = toString (pkgs.writeShellScript "panel" ''
        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          export DISPLAY=:0
          ${pkgs.sfwbar}/bin/sfwbar &
          export waidPID=$!
        else
          ${pkgs.lxqt.lxqt-panel}/bin/lxqt-panel &
          export waitPID=$!
        fi

        test -n $waitPID && wait $waitPID
      '');
      Restart = "always";
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
        action[1] = Exec "env GDK_BACKEND=x11 galendae -c /home/nyarla/.config/galendae/config"
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
        outline-width: 0px;
        padding-bottom: 0px;
        padding-top: 0px;
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
      min-height: 24px;
      min-width: 160px;
      padding-bottom; 4px;
      padding-left: 4px;
    }
  '';

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
