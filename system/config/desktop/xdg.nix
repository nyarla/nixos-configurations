{ pkgs, ... }:
let
  xdgPortalApps = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xdg-desktop-portal-luminous
  ];
in
{
  environment.systemPackages = xdgPortalApps ++ (with pkgs; [ xdg-utils ]);

  xdg.portal = {
    enable = true;
    extraPortals = xdgPortalApps;
    configPackages = with pkgs; [
      gnome-keyring
    ];
    config = {
      common = {
        default = [
          "gtk"
          "hyprland"
        ];

        # gtk
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];

        # gnome
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];

        # luminous
        "org.freedesktop.impl.portal.InputCapture" = [ "luminous" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "luminous" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];
      };
    };
  };
}
