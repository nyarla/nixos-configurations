{ pkgs, lib, ... }:
{
  systemd.services.waydroid-container.environment = {
    XDG_DATA_HOME = "/persist/home/nyarla/.local/share";
  };

  # clamav
  services.clamav.daemon.settings = {
    ExcludePath = [
      "^/backup"
      "^/dev"
      "^/home/nyarla/Reports"
      "^/nix"
      "^/persist/home/nyarla/Reports"
      "^/proc"
      "^/sys"
      "^/vm"
      ".snapshots/[0-9]+"
    ];
    MaxThreads = 30;
  };

  systemd.user.services.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "clamav-scan.sh" ''
          set -euo pipefail

          export PATH=${lib.makeBinPath (with pkgs; [ clamav ])}:$PATH

          clamdscan -l /home/nyarla/Reports/clamav.log -i -m --fdpass / || true

          exit 0
        ''
      );
    };
  };

  systemd.user.timers.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };

  # auto-purge memory cache
  systemd.services.cleanup-memory-cache = {
    enable = true;
    description = "Auto memory cache cleaner";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "cleanup-memory.sh" ''
          echo 3 > /proc/sys/vm/drop_caches
          echo 1 > /proc/sys/vm/compact_memory
        ''
      );
    };
  };

  # backup by restic
  systemd.services.backup = {
    enable = true;
    path =
      (with pkgs; [
        restic-run
        rclone
        sec
      ])
      ++ [
        "/run/wrappers"
      ];
    description = "Automatic backup by restic and rclone";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "backup.sh" ''
          set -euo pipefail
          export HOME=/home/nyarla

          if test -d /backup ; then
            cd /backup
            
            export RESTIC_PASSWORD=$(sudo -u nyarla env \
            DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
            SEC_ENV=deployment \
              sec /bin/sh -c 'echo $RESTIC_PASSWORD')

            restic-backup .
          fi

          exit 0
        ''
      );
    };
  };

  systemd.timers.backup = {
    enable = true;
    description = "Automatic backup by restic and rclone";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };
}
