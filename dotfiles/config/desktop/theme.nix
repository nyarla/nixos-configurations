{ pkgs, ... }:
let theme = import ../vars/theme.nix;
in {
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${theme.cursor.name}
  '';

  xresources.properties = {
    "Xcursor.size" = theme.cursor.size;
    "Xcursor.theme" = theme.cursor.name;
  };

  home.packages = with pkgs; [
    arc-openbox
    arc-theme
    capitaine-cursors
    flat-remix-icon-theme
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    hicolor-icon-theme
  ];
}
