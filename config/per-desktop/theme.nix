{ config, pkgs, ... }:
let
  themes = with pkgs; [
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    capitaine-cursors
    hicolor-icon-theme

    gtk-engine-murrine
    gtk_engines
    libsForQt5.qtstyleplugins
  ];
in {
  environment.variables = { QT_QPA_PLATFORMTHEME = "gtk3"; };
  environment.systemPackages = themes;
}
