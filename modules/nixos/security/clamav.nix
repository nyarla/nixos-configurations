{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.security.clamav;
in
{
  options.mod.security.clamav = {
    enable = mkEnableOption "clamav full-scan service";

    schedule = mkOption {
      type = types.str;
    };

    logFile = mkOption {
      type = types.str;
    };

    maxThreads = mkOption {
      type = types.int;
      default = 1;
    };

    mirrors = mkOption {
      type = types.listOf types.str;
      default = [ "db.jp.clamav.net" ];
    };

    excludes = mkOption {
      type = types.listOf types.str;
      default = [
        "^/dev"
        "^/nix"
        "^/proc"
        "^/sys"
        ".snapshots/[0-9]"
      ];
    };

    extraConfig = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          bool
          int
          str
          (listOf str)
        ]);
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ clamav ];

    services.clamav = {
      daemon.enable = true;
      daemon.settings = {
        ExcludePath = cfg.excludes;
        MaxThreads = cfg.maxThreads;
      }
      // cfg.extraConfig;

      updater.enable = true;
      updater.settings = {
        DatabaseMirror = cfg.mirrors;
      };
    };

    systemd.user.services.clamav-scan = {
      enable = true;
      description = "Full-scan by ClamAV";
      path = with pkgs; [ clamav ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = toString (
          pkgs.writeShellScript "clamav-full-scan.sh" ''
            set -euo pipefail
            clamdscan -l ${cfg.logFile} -i -m --fdpass / || true
            exit 0
          ''
        );
      };
    };

    systemd.user.timers.clamav-scan = {
      enable = true;
      description = "Full-scan by ClamAV with a timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.schedule;
        RandomizedDelaySec = "5m";
        Persistent = true;
      };
    };
  };
}
