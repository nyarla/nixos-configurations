{ pkgs, ... }:
let
  wineApps = let
    wine = pkgs.wineWowProtonFull;
    jackass-bin = pkgs.jackass-bin.override { inherit wine; };
    wineasio = pkgs.wineasio.override { inherit wine; };
    yabridge = pkgs.yabridge.override { inherit wine; };
    yabridgectl = pkgs.yabridgectl.override { inherit yabridge; };
  in [ wine jackass-bin wineasio yabridge yabridgectl ];
in {
  environment.systemPackages = wineApps ++ (with pkgs; [ winetricks wine-run ]);
}
