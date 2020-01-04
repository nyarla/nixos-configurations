{ config, pkgs, ... }:
let
  themes = with pkgs; [
    gnome3.adwaita-icon-theme gnome3.gnome-themes-extra
    plastik-theme newaita-icons capitaine-cursors
    gtk-engine-murrine
    qt5.full
  ];
in {
  qt5.enable = true;
  qt5.platformTheme = "gnome";
  qt5.style = "adwaita";
  environment.variables = { GTK_CSD = "0"; };
  environment.systemPackages = themes;
}
