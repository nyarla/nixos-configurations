{ pkgs, ... }: {
  systemd.user.services.blueman-applet = {
    Unit = {
      Description = "launch blueman-applet";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "LANG=ja_JP.UTF-8" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
