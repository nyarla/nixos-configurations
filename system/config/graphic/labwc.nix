{ pkgs, ... }: {
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.wlr.settings = {
    screencast = {
      output_name = "HDMI-A-1";
      max_fps = 30;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

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
    xdg-desktop-portal-wlr
  ];
}
