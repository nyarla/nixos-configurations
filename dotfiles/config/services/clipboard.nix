{ pkgs, ... }: {
  systemd.user.services.clipboard-sync = {
    Unit = {
      Description = "sync clipboard between wayland and xwayland";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.clipboard-sync}/bin/clipboard-sync";
    };
  };
}
