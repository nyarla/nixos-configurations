{ pkgs, ... }: {
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";

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
