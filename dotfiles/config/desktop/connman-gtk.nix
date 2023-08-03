{ config, ... }: {
  systemd.user.services.connmam-gtk = {
    Unit = {
      Description = "Autostart for connman-gtk";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "PATH=/run/current-system/sw/bin:${config.home.profileDirectory}/bin"
        "WAYLAND_DISPLAY=wayland-0"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "/run/current-system/sw/bin/connman-gtk --tray";
      Restart = "on-abort";
    };
  };
}
