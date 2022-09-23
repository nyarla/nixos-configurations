{ runCommand, writeShellScript, proot, restic, rclone, lib }:
let
  restic-exec = writeShellScript "restic-exec.sh" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [ restic rclone proot ]}:$PATH

    DIR="$1"

    if test "z$DIR" = "z"; then
      echo "Usage: restic-run name [...command]" >&2
      exit 1
    fi

    export HOME=/home/nyarla

    export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic
    export RESTIC_REPOSITORY=rclone:Teracloud:Restic/$DIR

    shift 1

    exec "''${@}"
  '';

  restic-run = writeShellScript "restic-run.sh" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [ restic rclone ]}:$PATH

    DIR="$1"

    if test "z$DIR" = "z"; then
      echo "Usage: restic-run name [...command]" >&2
      exit 1
    fi

    export HOME=/home/nyarla

    export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic
    export RESTIC_REPOSITORY=rclone:Teracloud:Restic/$DIR

    shift 1
    exec "''${@}"
  '';

  restic-backup = writeShellScript "restic-backup.sh" ''
    set -euo pipefail

    export RESTIC_FORGET_ARGS="--prune --keep-daily 7 --keep-weekly 3 --keep-monthly 3"
    export RESTIC_BACKUP_ARGS="--exclude-file $HOME/.config/rclone/ignore"

    DIR="$1"

    if test "z$DIR" = "z"; then
      echo "Usage: restic-backup [DIR]" >&2
      exit 1
    fi

    shift 1

    ${restic-run} "$DIR" ${restic}/bin/restic cache --cleanup
    ${restic-run} "$DIR" ${restic}/bin/restic unlock --remove-all
    ${restic-run} "$DIR" ${restic}/bin/restic rebuild-index
    ${restic-run} "$DIR" ${restic}/bin/restic prune
    ${restic-run} "$DIR" ${restic}/bin/restic backup $RESTIC_BACKUP_ARGS "$DIR"
    ${restic-run} "$DIR" ${restic}/bin/restic forget $RESTIC_FORGET_ARGS
  '';
in runCommand "restic-run" { } ''
  mkdir -p $out/bin
  cp ${restic-backup} $out/bin/restic-backup
  cp ${restic-exec} $out/bin/restic-exec
  cp ${restic-run} $out/bin/restic-run
  chmod +x $out/bin/*
''
