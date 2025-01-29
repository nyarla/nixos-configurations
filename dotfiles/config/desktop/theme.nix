{ pkgs, ... }:
{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Fluent-light";
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
    platformTheme.name = "gtk3";
    style.name = "kvantum";
    style.package = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
    ];
  };

  xdg.configFile."Kvantum/Fluent".source = with pkgs; "${fluent-kde}/share/Kvantum/Fluent";

  home.pointerCursor = {
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 24;

    gtk.enable = true;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    fluent-kde
    gnome-themes-extra
    gtk-engine-murrine
    gtk_engines
    hicolor-icon-theme
    kaunas
  ];
}
