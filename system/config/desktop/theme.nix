{ pkgs, config, ... }: {
  xdg.icons.enable = true;

  environment.sessionVariables = {
    GTK_THEME = "Arc";
    QT_STYLE_OVERRIDE = "kvantum";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "capitaine-cursors-white";
  };

  environment.systemPackages = with pkgs; [
    adwaita-qt
    adwaita-qt6
    arc-kde-theme
    arc-openbox
    arc-theme
    capitaine-cursors
    flat-remix-icon-theme
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    libsForQt5.qtstyleplugin-kvantum
    (libsForQt5.qtstyleplugin-kvantum.overrideAttrs (_: rec {
      pname = "qtstyleplugin-kvantum-qt6";
      nativeBuildInputs = [ cmake qt6.qttools ];
      buildInputs = [ qt6.qtsvg ];
      cmakeFlags = [ "-DENABLE_QT5=off" ];

      postPatch = ''
        sed -i "s!\''${_Qt6_PLUGIN_INSTALL_DIR}!$out/${qt6.qtbase.qtPluginPrefix}!" style/CMakeLists.txt
      '';

      dontWrapQtApps = true;
    }))
    qgnomeplatform
    qgnomeplatform-qt6
  ];
}
