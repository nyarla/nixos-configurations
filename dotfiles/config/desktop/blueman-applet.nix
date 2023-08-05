{ pkgs, config, ... }: {
  systemd.user.services.blueman-applet = {
    Unit = {
      Description = "launch blueman-applet";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      Restart = "always";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
