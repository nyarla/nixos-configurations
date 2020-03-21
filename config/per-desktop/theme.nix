{ config, pkgs, ... }:
let
  themes = with pkgs; [
    gnome3.adwaita-icon-theme gnome3.gnome-themes-extra
    zuki-themes newaita-icons capitaine-cursors
    gtk-engine-murrine
    qt5.full
  ];
in {
  programs.qt5ct.enable = true;
  environment.variables = { GTK_CSD = "0"; };
  environment.systemPackages = themes;
}
