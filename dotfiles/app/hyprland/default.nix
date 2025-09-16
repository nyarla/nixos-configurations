{ pkgs, ... }:
{
  imports = [
    ../../config/desktop/desktop-session.nix
    ../../config/desktop/theme.nix
  ];

  home.packages = with pkgs; [
    # wayland compositor
    hypridle
    hyprland
    hyprlock
    hyprnotify
    hyprshot

    hyprlandPlugins.hyprbars
    hyprlandPlugins.hyprexpo

    swaylock-effects # TODO: switch to hyprlock

    xwayland

    # desktop
    waybar
    wofi

    gyazo-diy
    libnotify
    libsecret
    mission-center

    # background services
    blueman
    networkmanagerapplet
    xembed-sni-proxy

    # utilities
    grim
    slurp
    wayout
    wev
    wlr-randr
    ydotool

    wl-clipboard
    xclip
  ];

  home.file.".local/bin/hy".source = toString (
    pkgs.writeShellScript "starthyprland" ''
      exec >$HOME/Reports/hyprland.log 2>&1

      for rc in $(ls /etc/profile.d); do
        . /etc/profile.d/$rc
      done

      for rc in $(ls $HOME/.config/profile.d); do
        . $HOME/.config/profile.d/$rc
      done

      export DESKTOP_SESSION=hyprland
      export LIBSEAT_BACKEND=logind

      export XDG_SESSION_CLASS=user
      export XDG_SESSION_TYPE=wayland

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

      dbus-run-session ${pkgs.hyprland}/bin/Hyprland
      cleanup
    ''
  );
}
