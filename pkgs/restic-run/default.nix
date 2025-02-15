{
  runCommand,
  writeShellScriptBin,
  restic,
  rclone,
  lib,
}:
let
  restic-run = writeShellScriptBin "restic-run" ''
    set -euo pipefail

    export PATH=${
      lib.makeBinPath [
        restic
        rclone
      ]
    }:$PATH

    export HOME=/home/nyarla

    export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic
    export RESTIC_REPOSITORY=rclone:Teracloud:Backup/NixOS

    exec "''${@}"
  '';

  restic-backup = writeShellScriptBin "restic-backup" ''
    set -euo pipefail

    export RESTIC_FORGET_ARGS="--prune --keep-daily 7 --keep-weekly 3 --keep-monthly 3"
    export RESTIC_BACKUP_ARGS="--exclude-file $HOME/.config/rclone/ignore"

    DIR="$1"

    if test "z$DIR" = "z"; then
      echo "Usage: restic-backup [DIR]" >&2
      exit 1
    fi

    shift 1

    ${restic-run}/bin/restic-run ${restic}/bin/restic cache --cleanup
    ${restic-run}/bin/restic-run ${restic}/bin/restic unlock --remove-all
    ${restic-run}/bin/restic-run ${restic}/bin/restic repair index
    ${restic-run}/bin/restic-run ${restic}/bin/restic prune
    ${restic-run}/bin/restic-run ${restic}/bin/restic backup $RESTIC_BACKUP_ARGS "$DIR"
    ${restic-run}/bin/restic-run ${restic}/bin/restic forget $RESTIC_FORGET_ARGS
  '';
in
runCommand "restic-run" { } ''
  mkdir -p $out/bin
  cp -r ${restic-run}/bin/* $out/bin/
  cp -r ${restic-backup}/bin/* $out/bin/
  chmod +x $out/bin/*
''
