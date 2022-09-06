{ pkgs, lib, config, ... }:
let
  clipsync = toString (pkgs.writeShellScript "clipsync.sh" ''
    set -xeuo pipefail

    export PATH=${
      lib.makeBinPath (with pkgs; [ wl-clipboard xclip clipnotify coreutils ])
    }:$PATH

    test -d $HOME/.cache/clipsync || mkdir -p $HOME/.cache/clipsync

    copy() {
      local section=$1
      local content="$(cat -)"

      if test "x$content" == "x"; then
        return
      fi

      if test -e "$HOME/.cache/clipsync/$section"; then
        local previous="$(cat "$HOME/.cache/clipsync/$section")"

        if test "$content" != "$previous" ; then
          echo "$content" >$HOME/.cache/clipsync/$section
          sync "$section" "$content" 
        fi
      else
        echo "$content" >$HOME/.cache/clipsync/$section
        sync "$section" "$content" 
      fi

      nohup bash -c "sleep $(( 5 * 60 )); ''${0} clean $section" >/dev/null 2>&1 &
    }

    paste() {
      local section="$1"

      if test -e $HOME/.cache/clipsync/$section ; then
        cat $HOME/.cache/clipsync/$section
      fi
    }

    clean() {
      rm -f $HOME/.cache/clipsync/*
    }

    sync() {
      local section=$1
      local content=$2

      if test -z "$content"; then
        return
      fi

      if test "x$(which wl-copy)" != "x"; then
        if test "$section" == "primary" ; then
          echo "$content" | wl-copy -p
        else
          echo "$content" | wl-copy
        fi
      fi

      if test "x$(which xclip)" != "x"; then
        if test "$section" == "primary"; then
          echo "$content" | xclip -i -selection primary
        elif test "$section" == "clipboard" ; then
          echo "$content" | xclip -i -selection clipboard
        fi
      fi
    }

    case "$1" in
      copy)
        cat - | copy $2
        ;;
      paste)
        paste $2
        ;;
      clean)
        clean $2
        ;;
    esac
  '');

  mkClipSyncService = { Description, ExecStart }: {
    Unit = {
      inherit Description;
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      inherit ExecStart;
      Type = "simple";
      Restart = "on-failure";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
in {
  systemd.user.services.clipsync-wayland-to-xorg-primary = mkClipSyncService {
    Description = "Sync clipboard from wayland to xorg (primary)";
    ExecStart =
      "${pkgs.wl-clipboard}/bin/wl-paste -p -w ${clipsync} copy primary";
  };

  systemd.user.services.clipsync-wayland-to-xorg-clipboard = mkClipSyncService {
    Description = "Sync clipboard from wayland to xorg (clipboard)";
    ExecStart =
      "${pkgs.wl-clipboard}/bin/wl-paste -w ${clipsync} copy clipboard";
  };
}
