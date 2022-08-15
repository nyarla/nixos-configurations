{ pkgs, ... }: {
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
    sfwbar
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
}
