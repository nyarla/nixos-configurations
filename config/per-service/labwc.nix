{ pkgs, ... }:
let
  apps = (with pkgs; [
    clipman
    grim
    kanshi
    labwc
    mako
    swaybg
    swaylock
    waybar
    wev
    wlay
    wlr-randr
    wtype
  ]);
in {
  imports = [ ./fonts.nix ./theme.nix ./gnome-compatible.nix ./gsettings.nix ];

  environment.systemPackages = apps;

  security.wrappers = {
    "labwc" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.labwc}/bin/labwc";
    };
  };
  security.pam.services.swaylock = { };
}
