{ pkgs, ... }: {
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings = {
    screencast = {
      output_name = "HDMI-A-1";
      max_fps = 30;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

  services.pipewire.enable = true;
}
