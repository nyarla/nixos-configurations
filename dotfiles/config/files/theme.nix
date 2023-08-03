_: {
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=capitaine-cursors-white
  '';

  xresources.properties = {
    "Xcursor.size" = 24;
    "Xcursor.theme" = "capitaine-cursors-white";
  };
}
