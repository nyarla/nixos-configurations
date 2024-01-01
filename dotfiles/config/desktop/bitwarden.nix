{ config, ... }: {
  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Autostart for Bitwarden";
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
      ExecStart = "/etc/profiles/per-user/nyarla/bin/bitwarden --silent";
      Restart = "always";
    };
  };
}
