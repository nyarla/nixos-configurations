{ pkgs, ... }:
let
  xdgPortalApps = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hypr-remote
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
  ];
in
{
  environment.systemPackages = xdgPortalApps ++ (with pkgs; [ xdg-utils ]);

  xdg.portal = {
    enable = true;
    extraPortals = xdgPortalApps;
    configPackages = with pkgs; [
      gnome-keyring
      hyprland
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
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "hypr-remote" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.ScreenShot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Settings" = [ "luminous" ];
      };
    };
  };
}
