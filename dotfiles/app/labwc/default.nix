{ pkgs, ... }: {
  imports = [
    ../../config/desktop/bitwarden.nix
    ../../config/desktop/cmst.nix
    ../../config/desktop/desktop-panel.nix
    ../../config/desktop/desktop-session.nix
    ../../config/desktop/dunst.nix
    ../../config/desktop/swaylock.nix
    ../../config/desktop/theme.nix
    ../../config/desktop/ydotoold.nix
  ];

  home.packages = with pkgs; [
    # terminal
    wezterm

    # credential
    libsecret

    # wayland
    grim
    slurp
    wl-clipboard

    labwc
    swaybg
    swayidle
    swaylock-effects

    wayout
    wev
    wlr-randr
    wmname
    ydotool

    galendae
  ];

  xdg.configFile = {
    "labwc/autostart".source = toString (with pkgs;
      (import ./autostart.nix) { inherit fetchurl writeShellScript pkgs; });

    "labwc/menu.xml".text = import ../../config/vars/appmenu.nix {
      inherit pkgs;
      isWayland = true;
    };
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

  home.file.".local/bin/sw".source = let
    Xwayland = pkgs.writeShellScript "Xwayland" ''
      exec -a Xwayland ${pkgs.xwayland}/bin/Xwayland "''${@}" -eglstream
    '';
  in toString (pkgs.writeShellScript "startlabwc" ''
    for rc in $(ls /etc/profile.d); do
      . /etc/profile.d/$rc
    done

    for rc in $(ls $HOME/.config/profile.d); do
      . $HOME/.config/profile.d/$rc
    done

    export DESKTOP_SESSION=wlroots
    export LIBSEAT_BACKEND=logind

    export XDG_CURRENT_DESKTOP=wlroots
    export XDG_SESSION_CLASS=user
    export XDG_SESSION_DESKTOP=wlroots
    export XDG_SESSION_TYPE=wayland

    export GBM_BACKEND=nvidia-drm
    export GBM_BACKENDS_PATH=/etc/gbm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    export LIBVA_DRIVER_NAME=nvidia
    export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json
    export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d
    export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json
    export __GL_GSYNC_ALLOWED=1
    export __GL_VRR_ALLOWED=0

    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    export WLR_RENDERER=gles2
    export WLR_DRM_NO_ATOMIC=1
    export WLR_XWAYLAND=${Xwayland}
    export XWAYLAND_NO_GLAMOR=1

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

    eval "$(dbus-launch --sh-syntax --exit-with-session)"
    ${pkgs.labwc}/bin/labwc -V &
    waidPID=$!

    test -n $waidPID && wait $waidPID

    cleanup
  '');
}
