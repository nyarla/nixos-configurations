{ pkgs, ... }: {
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  services.gnome.gnome-remote-desktop.enable = true;

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita";

  services.pipewire.enable = true;
  environment.systemPackages = with pkgs; [
    gtk-engine-murrine
    gtk_engines
    qgnomeplatform
    qgnomeplatform-qt6
    adwaita-qt
    adwaita-qt6
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  security.wrappers = {
    "Xorg" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.xorg.xorgserver}/bin/Xorg";
    };
  };
}
