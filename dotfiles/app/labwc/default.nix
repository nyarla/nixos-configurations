{ pkgs, ... }: {
  imports = [
    ../../config/services/blueman-applet.nix
    ../../config/services/clipboard.nix
    ../../config/services/fcitx5.nix
    ../../config/services/gnome-keyring.nix
    ../../config/services/polkit.nix
    ../../config/services/sfwbar.nix
  ];

  home.packages = with pkgs; [
    # icon and themes
    arc-theme
    arc-openbox
    capitaine-cursors
    hicolor-icon-theme
    flat-remix-icon-theme

    # fallback
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra

    # theme engine
    gtk-engine-murrine
    gtk_engines
    qgnomeplatform

    # wayland
    clipman
    grim
    slurp
    wl-clipboard

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

    SDL_VIDEODRIVER=wayland
    _JAVA_AWT_WM_NONREPARENTING=1

    MOZ_ENABLE_WAYLAND=1
    MOZ_WEBRENDER=1
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
      export GBM_BACKEND_PATH=/etc/gbm

      export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.json
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export LIBSEAT_BACKEND=logind

      export WLR_NO_HARDWARE_CURSORS=1
      #export WLR_RENDERER=vulkan

      labwc &
      waitPID=$!

      systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS XDG_SESSION_ID XDG_SESSION_TYPE  
      systemctl --user import-environment LD_LIBRARY_PATH GIO_EXTRA_MODULES GI_TYPELIB_PATH
      systemctl --user start graphical-session.target

      dbus-update-activation-environment --systemd --all

      test -n "$waitPID" && wait "$waitPID"

      systemctl --user stop graphical-session.target

      exit 0
    '';
  };
}
