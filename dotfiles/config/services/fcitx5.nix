{ pkgs, ... }: {
  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "launch fcitx5";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "/run/current-system/sw/bin/fcitx5";
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "LANG=ja_JP.UTF-8" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
