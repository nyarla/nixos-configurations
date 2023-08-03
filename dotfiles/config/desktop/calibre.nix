{ pkgs, config, ... }: {
  systemd.user.services.calibre = {
    Unit = {
      Description = "Autostart for calibre";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "PATH=/run/current-system/sw/bin:${config.home.profileDirectory}/bin"
        "WAYLAND_DISPLAY=wayland-0"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "${pkgs.calibre}/bin/calibre --start-in-tray";
      Restart = "on-abort";
    };
  };
}
