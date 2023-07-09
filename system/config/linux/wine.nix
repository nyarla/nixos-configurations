{ config, pkgs, ... }:
let
  wineApps = let
    wine = pkgs.wineWowPackages.stagingFull;
    winetricks = pkgs.winetricks;
    jackass-bin = pkgs.jackass-bin.override { inherit wine; };
    wineasio = pkgs.wineasio.override { inherit wine; };
    yabridge = pkgs.yabridge.override { inherit wine; };
    yabridgectl = pkgs.yabridgectl.override { inherit yabridge; };
  in [ wine winetricks ];
in { environment.systemPackages = wineApps ++ (with pkgs; [ wine-run ]); }
