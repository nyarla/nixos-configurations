{ config, pkgs, ... }: {
  systemd.user.services.cmst = {
    Unit = {
      Description = "Autostart for connman-gtk";
      After = [ "graphical-session.target" "desktop-panel.service" ];
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
      ExecStart = "${pkgs.cmst}/bin/cmst -m";
      Restart = "always";
    };
  };
}
