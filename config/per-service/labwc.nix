{ pkgs, ... }:
let
  apps = (with pkgs; [
    clipman
    grim
    kanshi
    mako
    swaybg
    swaylock
    waybar
    wev
    wlay
    wlr-randr
    wtype
    labwc
  ]);
in {
  imports = [
    ../per-desktop/fonts.nix
    ../per-desktop/theme.nix
    ../per-service/gnome-compatible.nix
    ../per-service/gsettings.nix
  ];

  environment.systemPackages = apps;

  security.wrappers = {
    "labwc" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.labwc}/bin/labwc";
    };
  };
}
