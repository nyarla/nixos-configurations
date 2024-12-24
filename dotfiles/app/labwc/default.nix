{ pkgs, lib, ... }:
{
  imports = [
    ../../config/desktop/desktop-panel.nix
    ../../config/desktop/desktop-session.nix
    ../../config/desktop/dunst.nix
    ../../config/desktop/swaylock.nix
    ../../config/desktop/theme.nix
    ../../config/desktop/ydotoold.nix
  ];

  home.packages = with pkgs; [
    # credential
    libsecret

    # desktop
    mate.mate-system-monitor

    # wayland
    grim
    slurp
    wl-clipboard
    xclip
    gyazo-diy

    labwc
    swaybg
    swayidle
    swaylock-effects
    goreman

    wayout
    wev
    wlr-randr
    ydotool

    galendae
  ];

  xdg.configFile = {
    "labwc/autostart".source = toString (
      (import ./autostart.nix) {
        inherit pkgs;
        inherit (pkgs) fetchurl writeShellScript;
      }
    );

    "labwc/menu.xml".text = import ../../config/vars/appmenu.nix { inherit lib; };
    "labwc/rc.xml".text = (import ./rc.nix) { };

    "labwc/environment".text = ''
      GTK2_RC_FILES=$HOME/.gtkrc-2.0

      LANG=ja_JP.UTF_8
      LC_ALL=ja_JP.UTF-8

      XKB_DEFAULT_LAYOUT=us

      GDK_BACKEND=wayland
      CLUTTER_BACKEND=wayland
      QT_QPA_PLATFORM=wayland

      MOZ_DISABLE_RDD_SANDBOX=1
      MOZ_ENABLE_WAYLAND=1
      MOZ_USE_XINPUT2=1
      MOZ_WEBRENDER=1

      SDL_VIDEODRIVER=wayland
      _JAVA_AWT_WM_NONREPARENTING=1
    '';
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

      export DESKTOP_SESSION=wlroots
      export LIBSEAT_BACKEND=logind

      export XDG_CURRENT_DESKTOP=labwc:wlroots
      export XDG_SESSION_CLASS=user
      export XDG_SESSION_DESKTOP=labwc:wlroots
      export XDG_SESSION_TYPE=wayland

      export WLR_RENDERER_ALLOW_SOFTWARE=1
      export WLR_RENDERER=gles2

      if systemctl --user -q is-active desktop-session.target ; then
        echo "Desktop session already exists." >&2
        exit 1
      fi

      if hash dbus-update-activation-environment 2>/dev/null; then
        dbus-update-activation-environment --systemd --all
      fi

      systemctl --user reset-failed

      cleanup() {
        pkill shoreman
        if systemctl --user -q is-active desktop-session.target ; then
          systemctl --user stop desktop-session.target
        fi
      }
      trap cleanup INT TERM

      dbus-launch --exit-with-session ${pkgs.labwc}/bin/labwc -V
      cleanup
    ''
  );
}
