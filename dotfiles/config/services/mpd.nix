{ pkgs, ... }: {
  systemd.user.services.mympd = {
    Unit = {
      Description = "Screen lock services by sway utilites";
      After = [ "network.target" ];
      PartOf = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart =
        "${pkgs.mympd}/bin/mympd mympd -u nyarla -w /home/nyarla/.config/mympd -a /home/nyarla/.cache/mympd";
    };

    Install = { WantedBy = [ "network.target" ]; };
  };
}
