{ runCommand, writeShellScript, restic, rclone }:
let
  restic-run = writeShellScript "restic-run.sh" ''
    set -euo pipefail

    if test -z "''${1:-}" ; then
      echo "Usage: ''${0} <name> [restic args...]" >&2
      exit 1
    fi

    export HOME=/home/nyarla
    export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic

    export RESTIC_REPOSITORY=rclone:Teracloud:Restic/$(hostname)/''${1}

    shift 1

    cmd=''${1:-}
    shift 1

    args=(''${@})

    exec ${restic}/bin/restic $cmd -o=rclone.program="${rclone}/bin/rclone" ''${args[@]}
  '';

  restic-backup = writeShellScript "restic-backup.sh" ''
    set -euo pipefail

    export RESTIC_FORGET_ARGS="--prune --keep-daily 7 --keep-weekly 2 --keep-monthly 3"
    export RESTIC_BACKUP_ARGS="--exclude-file $HOME/.config/rclone/ignore"

    if test -z "''${1:-}" ; then
      echo "Usage: ''${0} <name> [restic args...]" >&2
      exit 1
    fi

    repo=''${1:-}
    shift 1

    args=(''${@})

    ${restic-run} $repo unlock --remove-all
    ${restic-run} $repo rebuild-index
    ${restic-run} $repo prune
    ${restic-run} $repo backup $RESTIC_BACKUP_ARGS ''${args[@]}
    ${restic-run} $repo forget $RESTIC_FORGET_ARGS
  '';
in runCommand "restic-run" { } ''
  mkdir -p $out/bin
  cp ${restic-run} $out/bin/restic-run
  cp ${restic-backup} $out/bin/restic-backup
  chmod +x $out/bin/*
''
