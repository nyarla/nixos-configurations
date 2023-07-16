{ pkgs, lib, ... }: {
  systemd.user.services.backup = {
    Unit = { Description = "Automatic backup by restic and rclone"; };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "backup.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ restic-run ])}:$PATH

        if test -d /backup ; then
          cd /backup
          restic-backup .
        fi

        exit 0
      '';
    };
  };

  systemd.user.timers.backup = {
    Unit = { Description = "Automatic backup by restic and rclone"; };

    Timer = {
      OnCalendar = "*-*-* 01:00:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
      Unit = "backup.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
