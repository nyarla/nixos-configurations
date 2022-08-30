{ pkgs, ... }: {
  systemd.user.services.clipboard-wayland-to-xorg = {
    Unit = {
      Description = "Sync clipboard wayland to xwayland";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = toString (pkgs.writeShellScript "sync-w2x.sh" ''
        ${pkgs.wl-clipboard}/bin/wl-paste -w ${pkgs.xclip}/bin/xclip -i
      '');
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "DISPLAY=:0" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  systemd.user.services.clipboard-xorg-to-wayland = {
    Unit = {
      Description = "Sync clipboard wayland to xwayland";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = toString (pkgs.writeShellScript "sync-x2w.sh" ''
        ${pkgs.xclip}/bin/xclip -l -o | ${pkgs.wl-clipboard}/bin/wl-copy
      '');
      Environment = [ "WAYLAND_DISPLAY=wayland-0" "DISPLAY=:0" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
