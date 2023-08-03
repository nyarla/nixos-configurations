{ pkgs, ... }:
let
  swaylock-script = toString (with pkgs;
    writeShellScript "swaylock.sh" ''
      ${swayidle}/bin/swayidle -w \
        timeout 60 '${swaylock}/bin/swaylock -f' \
        timeout 90 '${wayout}/bin/wayout --off HDMI-A-1' resume '${wayout}/bin/wayout --on HDMI-A-1'
        before-sleep '${swaylock}/bin/swaylock -f' \
        lock '${swaylock}/bin/swaylock -f'
    '');
in {
  systemd.user.services.swaylock = {
    Unit = {
      Description = "Screen lock services by sway utilites";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = swaylock-script;
      Environment = [ "WAYLAND_DISPLAY=wayland-0" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
