{ pkgs, ... }:
{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Fluent";
      package = pkgs.fluent-icon-theme;
    };

    theme = {
      name = "Fluent-Light-compact";
      package = pkgs.fluent-gtk-theme;
    };

    font = {
      name = "Sans";
      size = 9;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "kvantum";
  };

  home.pointerCursor = {
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 24;

    gtk.enable = true;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    kaunas
  ];
}
