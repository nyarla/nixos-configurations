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
      "^/run"
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
  systemd.user.services.backup-local = {
    enable = true;
    description = "Scheduled local backup by restic";
    path = with pkgs; [
      libsecret
      rclone
      restic
    ];
    environment = {
      RESTIC_REPOSITORY = "/persist/data/DBF4-42B3/Backup";
      RESTIC_PASSWORD_COMMAND = "secret-tool lookup restic-token local";
    };
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/backup";
      ExecStart = toString (
        pkgs.writeShellScript "backup.sh" ''
          set -eou pipefail

          if [[ ! -e "''${RESTIC_REPOSITORY}" ]]; then
            echo "Backup repository is not found" >&2
            exit 1
          fi

          restic cache --cleanup
          restic unlock --remove-all
          restic repair index
          restic prune
          restic backup --exclude-file Sync/.resticignore . || true
          restic forget --prune --keep-weekly 7 --keep-monthly 4
        ''
      );
    };
  };
  systemd.user.services.backup-remote = {
    enable = true;
    description = "Scheduled remote backup by restic";
    path = with pkgs; [
      libsecret
      rclone
      restic
    ];
    environment = {
      RESTIC_REPOSITORY = "rclone:infinicloud:Backup/NixOS";
      RESTIC_PASSWORD_COMMAND = "secret-tool lookup restic-token remote";
    };
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/backup";
      ExecStart = toString (
        pkgs.writeShellScript "backup.sh" ''
          set -euo pipefail

          export RCLONE_WEBDAV_PASS="$(secret-tool lookup restic-token rclone)"

          restic cache --cleanup
          restic unlock --remove-all
          restic repair index
          restic prune
          restic backup --exclude-file Sync/.resticignore.remote . || true
          restic forget --prune --keep-weekly 7 --keep-monthly 4
        ''
      );
    };
  };

  systemd.user.timers.backup-local = {
    enable = true;
    description = "Timer for local backup by restic";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };

  systemd.user.timers.backup-remote = {
    enable = true;
    description = "Timer for local backup by restic";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:30:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };
}
