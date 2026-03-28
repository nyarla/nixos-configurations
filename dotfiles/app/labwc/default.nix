{ pkgs, ... }:
{
  imports = [
    ../../config/desktop/desktop-session.nix
    ../../config/desktop/theme.nix
  ];

  home.packages = with pkgs; [
    # wayland compositor
    labwc-toplevel-capture

    swaybg
    swayidle
    swaylock-effects

    xwayland

    kaunas

    # desktop
    goreman
    lxqt.lxqt-panel
    wofi

    gyazo-diy
    libnotify
    libsecret
    mission-center

    # background service
    blueman
    networkmanagerapplet
    xembed-sni-proxy
    gcr

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

  xdg.dataFile."backgrounds/default.png".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
    sha256 = "1282cnqc5qynp0q9gdll7bgpw23yp5bhvaqpar59ibkh3iscg8i5";
  };

  home.file.".local/bin/sw".source = toString (
    pkgs.writeShellScript "startlabwc" ''
      exec >$HOME/Reports/sw.log 2>&1

      for rc in $(ls /etc/profile.d); do
        . /etc/profile.d/$rc
      done

      for rc in $(ls $HOME/.config/profile.d); do
        . $HOME/.config/profile.d/$rc
      done

      export DESKTOP_SESSION=labwc:wlroots
      export LIBSEAT_BACKEND=logind

      export XDG_CURRENT_DESKTOP=labwc:wlroots
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

      eval "$(/run/wrappers/bin/gnome-keyring-daemon --components=secrets,pkcs11 --replace)"
      export GNOME_KEYRING_CONTROL

      labwc
      cleanup
    ''
  );
}
