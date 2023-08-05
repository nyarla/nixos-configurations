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
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
        "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}"
      ];
      ExecStart = "${pkgs.lxqt.lxqt-panel}/bin/lxqt-panel";
      Restart = "always";
    };
  };
}
