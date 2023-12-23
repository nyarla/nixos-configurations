{ pkgs, config, ... }: {
  systemd.user.services.jackd = {
    Unit = {
      Description = "Autostart Jack Audio Connection Kit";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
      Type = "simple";
      Restart = "always";
      Environment = [ "HOME=${config.home.homeDirectory}" ];
      ExecStart = "${pkgs.qjackctl}/bin/qjackctl";
    };
  };

  home.packages = with pkgs; [ jack-example-tools jack2Full qjackctl ];
}
