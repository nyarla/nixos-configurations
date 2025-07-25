{ pkgs, ... }:
let
  xdgPortalApps = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hypr-remote
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-xapp
  ];
in
{
  environment.systemPackages = xdgPortalApps ++ (with pkgs; [ xdg-utils ]);

  xdg.portal = {
    enable = true;
    extraPortals = xdgPortalApps;
    configPackages = with pkgs; [
      hyprland
    ];
    config = {
      hyprland = {
        default = [
          "hyrpland"
          "gtk"
          "hypr-remote"
        ];
      };
    };
  };
}
