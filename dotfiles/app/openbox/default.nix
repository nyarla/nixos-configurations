{ pkgs, ... }:
{
  imports = [
    ../../config/desktop/bitwarden.nix
    ../../config/desktop/cmst.nix
    ../../config/desktop/desktop-panel.nix
    ../../config/desktop/desktop-session.nix
    ../../config/desktop/dunst.nix
    ../../config/desktop/picom.nix
    ../../config/desktop/theme.nix
    ../../config/desktop/xorg.nix
    ../../config/desktop/ydotoold.nix
  ];

  home.packages =
    with pkgs;
    [
      # terminal
      wezterm

      # credential
      libsecret

      # clipboard
      clipit

      # utility
      lxappearance

      # panel
      lxqt.lxqt-config

      # screen lock
      i3lock-fancy
      xss-lock

      jq
      maim
      mate.mate-system-monitor
      obconf
      openbox
      perl
      s5cmd
      sxhkd
      wmctrl
      xsettingsd
      ydotool
    ]
    ++ lxqt.preRequisitePackages;

  xdg.configFile = {
    # openbox
    "openbox/autostart".source = toString (
      with pkgs; (import ./autostart.nix) { inherit fetchurl writeShellScript pkgs; }
    );

    "openbox/menu.xml".text = import ../../config/vars/appmenu.nix {
      inherit pkgs;
      isXorg = true;
    };

    "openbox/environment".source = toString (
      pkgs.writeScript "environment" ''
        export GTK2_RC_FILES=$HOME/.gtkrc-2.0

        export LANG=ja_JP.UTF_8
        export LC_ALL=ja_JP.UTF-8

        export MOZ_DISABLE_RDD_SANDBOX=1
        export NVD_BACKEND=direct
      ''
    );

    "openbox/rc.xml".text = (import ./rc.nix) { };

    "sx/sxrc".source = toString (
      pkgs.writeShellScript "startx" ''
        set -eo pipefail

        for rc in $(ls /etc/profile.d); do
          . /etc/profile.d/$rc
        done

        for rc in $(ls $HOME/.config/profile.d); do
          . $HOME/.config/profile.d/$rc
        done

        export DESKTOP_SESSION=openbox

        export XDG_CONFIG_DIRS=/etc/xdg:/home/''${USER}/.nix-profile/etc/xdg:/etc/profiles/per-user/''${USER}/etc/xdg:/nix/var/nix/profiles/default/etc/xdg:/run/current-system/sw/etc/xdg
        export XDG_CURRENT_DESKTOP=openbox
        export XDG_SESSION_CLASS=user
        export XDG_SESSION_DESKTOP=openbox
        export XDG_SESSION_TYPE=x11

        if systemctl --user -q is-active desktop-session.target ; then
          echo "Desktop session already exists." >&2
          exit 1
        fi

        if hash dbus-update-activation-environment 2>/dev/null; then
          dbus-update-activation-environment --systemd --all
        fi

        systemctl --user reset-failed

        cleanup() {
          if systemctl --user -q is-active desktop-session.target ; then
            systemctl --user stop desktop-session.target
          fi
        }

        trap cleanup INT TERM

        eval "$(dbus-launch --sh-syntax --exit-with-session)"
        ${pkgs.openbox}/bin/openbox-session &
        waidPID=$!

        test -n $waidPID && wait $waidPID

        cleanup
      ''
    );
  };
}
