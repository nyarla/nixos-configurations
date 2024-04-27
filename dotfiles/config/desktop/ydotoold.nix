{ pkgs, config, ... }:
{
  systemd.user.services.ydotoold = {
    Unit = {
      Description = "Autostart for ydotoold";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "${pkgs.ydotool}/bin/ydotoold";
      Restart = "always";
    };
  };
}
