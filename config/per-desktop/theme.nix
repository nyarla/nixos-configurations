{ config, pkgs, ... }:
let
  themes = with pkgs; [
    gnome3.gnome-themes-extra
    zuki-themes
    newaita-icons
    capitaine-cursors
    gtk-engine-murrine
    qt5.full
    libsForQt5.qtstyleplugins
  ];
in
{
  environment.variables = {
    GTK_CSD = "0";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  environment.systemPackages = themes;
}
