{ pkgs, ... }: {
  xdg.icons.enable = true;

  environment.sessionVariables = {
    GTK_THEME = "Fluent-Light-compact";
    QT_STYLE_OVERRIDE = "kvantum";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "capitaine-cursors-white";
  };

  environment.systemPackages = with pkgs; [
    capitaine-cursors
    fluent-gtk-theme
    fluent-icon-theme
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    kaunas
  ];

  qt = {
    enable = true;
    style = "kvantum";
  };
}
