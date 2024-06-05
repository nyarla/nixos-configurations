{ pkgs, ... }:
let
  xdgPortalApps = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xdg-desktop-portal-xapp
  ];
in
{
  environment.systemPackages = xdgPortalApps ++ (with pkgs; [ xdg-utils ]);

  xdg.portal = {
    enable = true;
    extraPortals = xdgPortalApps;
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };

    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "HDMI-A-3";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
