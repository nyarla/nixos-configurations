{ pkgs, ... }:
{
  systemd.user.services.polkit-mate-authentication-agent-1 = {
    Unit = {
      Description = "launch authentication-agent-1";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = ''
        ${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1
      '';
      Environment = [
        "LANG=ja_JP.UTF-8"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
