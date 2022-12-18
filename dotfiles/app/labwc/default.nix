{ pkgs, ... }: {
  imports = [
    ../../config/services/blueman-applet.nix
    ../../config/services/gnome-keyring.nix
    ../../config/services/polkit.nix
    ../../config/services/sfwbar.nix
    ../../config/services/swaylock.nix
  ];

  home.packages = with pkgs; [
    # icon and themes
    arc-openbox
    arc-theme
    capitaine-cursors
    flat-remix-icon-theme
    hicolor-icon-theme

    # fallback
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra

    # wayland
    grim
    slurp
    wl-clipboard
    xclip

    labwc
    swaybg
    swayidle
    swaylock-effects
    xembed-sni-proxy

    wayout
    wev
    wlr-randr
    wmname
    ydotool
  ];

  xdg.configFile."labwc/autostart".source = toString (with pkgs;
    (import ./autostart.nix) { inherit fetchurl writeShellScript pkgs; });

  xdg.configFile."labwc/menu.xml".text = (import ./menu.nix) { };
  xdg.configFile."labwc/rc.xml".text = (import ./rc.nix) { };

  xdg.configFile."labwc/environment".text = ''
    GTK2_RC_FILES=$HOME/.gtkrc-2.0

    LANG=ja_JP.UTF_8
    LC_ALL=ja_JP.UTF-8

    XKB_DEFAULT_LAYOUT=us

    GDK_BACKEND=wayland
    GTK_CSD=0
    GTK_THEME=Arc

    CLUTTER_BACKEND=wayland

    QT_QPA_PLATFORM=wayland
    QT_QPA_PLATFORMTHEME=gnome
    QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    MOZ_ENABLE_WAYLAND=1
    MOZ_WEBRENDER=1
    MOZ_USE_XINPUT2=1

    SDL_VIDEODRIVER=wayland
    _JAVA_AWT_WM_NONREPARENTING=1
  '';

  home.file.".local/bin/sw" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      for rc in $(ls /etc/profile.d); do
        . /etc/profile.d/$rc
      done

      for rc in $(ls $HOME/.config/profile.d); do
        . $HOME/.config/profile.d/$rc
      done

      export XCURSOR_PATH=/run/current-system/etc/profiles/per-user/nyarla/share/icons:$HOME/.icons/default
      export XCURSOR_THEME=capitaine-cursors-white

      schema="org.gnome.desktop.interface"
      gsettings set $schema gtk-theme "Arc"
      gsettings set $schema icon-theme "Flat-Remix-Cyan-Light"
      gsettings set $schema cursor-theme $XCURSOR_THEME
      gsettings set $schema font-name "Sans 9"

      export XDG_DATA_DIRS=$HOME/.local/share:/run/current-system/etc/profiles/per-user/nyarla/share:$XDG_DATA_DIRS

      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=wlroots

      export GBM_BACKEND=nvidia-drm
      export GBM_BACKENDS_PATH=/etc/gbm

      export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json
      export __EGL_VENDOR_LIBRARY_DIRS=/etc/glvnd/egl_vendor.d
      export __GL_GSYNC_ALLOWED=0
      export __GL_VRR_ALLOWED=0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export LIBSEAT_BACKEND=logind

      export WLR_NO_HARDWARE_CURSORS=1
      # export WLR_RENDERER=vulkan

      dbus-update-activation-environment --systemd --all

      labwc -V &
      waitPID=$!

      systemctl --user start graphical-session.target

      test -n "$waitPID" && wait "$waitPID"

      systemctl --user stop graphical-session.target

      exit 0
    '';
  };
}
