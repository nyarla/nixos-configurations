{ config, ... }: {
  systemd.user.services._1password = {
    Unit = {
      Description = "Autostart for 1password";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "/run/current-system/sw/bin/1password --silent";
      Restart = "on-failure";
    };
  };
}
