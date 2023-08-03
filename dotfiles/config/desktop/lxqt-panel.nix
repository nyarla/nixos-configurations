{ pkgs, config, ... }: {
  systemd.user.services.lxqt-panel = {
    Unit = {
      Description = "Autostart for LXQt-Panel";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
        "PATH=/run/current-system/sw/bin:${config.home.profileDirectory}/bin"
        "QT_QPA_PLATFORMTHEME=${config.home.sessionVariables.QT_QPA_PLATFORMTHEME}"
        "WAYLAND_DISPLAY=wayland-0"
        "XDG_DATA_DIRS=/run/current-system/sw/share:/run/current-system/etc/profiles/per-user/nyarla/share"
      ];
      ExecStart = "${pkgs.lxqt.lxqt-panel}/bin/lxqt-panel";
      Restart = "on-abort";
    };
  };
}
