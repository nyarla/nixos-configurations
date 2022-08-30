{ pkgs, ... }:
let
  mkGnomeKeyringService = component: {
    Unit = {
      Description = "launch gnome-keyring-${component}";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart =
        "/run/wrappers/bin/gnome-keyring-daemon --start --foreground --components=${component}";
      Environment = [ "LANG=ja_JP.UTF-8" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
in {
  systemd.user.services.gnome-keyring-pkcs11 = mkGnomeKeyringService "pkcs11";
  systemd.user.services.gnome-keyring-secrets = mkGnomeKeyringService "secrets";
  systemd.user.services.gnome-keyring-ssh = mkGnomeKeyringService "ssh";
}
