{ runCommand, writeShellScript, proot, restic, rclone, lib }:
let
  restic-run = writeShellScript "restic-run.sh" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [ restic rclone ]}:$PATH

    export HOME=/home/nyarla

    export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic
    export RESTIC_REPOSITORY=rclone:Teracloud:Backup/NixOS

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

    ${restic-run} ${restic}/bin/restic cache --cleanup
    ${restic-run} ${restic}/bin/restic unlock --remove-all
    ${restic-run} ${restic}/bin/restic rebuild-index
    ${restic-run} ${restic}/bin/restic prune
    ${restic-run} ${restic}/bin/restic backup $RESTIC_BACKUP_ARGS "$DIR"
    ${restic-run} ${restic}/bin/restic forget $RESTIC_FORGET_ARGS
  '';
in runCommand "restic-run" { } ''
  mkdir -p $out/bin
  cp ${restic-backup} $out/bin/restic-backup
  cp ${restic-run} $out/bin/restic-run
  chmod +x $out/bin/*
''
