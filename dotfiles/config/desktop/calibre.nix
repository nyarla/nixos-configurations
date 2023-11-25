{ pkgs, config, ... }: {
  systemd.user.services.calibre = {
    Unit = {
      Description = "Autostart for calibre";
      After = [ "graphical-session.target" "desktop-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "${pkgs.calibre}/bin/calibre --start-in-tray";
      Restart = "always";
    };
  };
}
