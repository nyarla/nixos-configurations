{ pkgs, ... }:
let
  wineApps = let
    wine = pkgs.wineUsingFull;
    jackass-bin = pkgs.jackass-bin.override { inherit wine; };
    wineasio = pkgs.wineasio.override { inherit wine; };
    yabridge = pkgs.yabridge.override { inherit wine; };
    yabridgectl = pkgs.yabridgectl.override { inherit yabridge wine; };
  in [ wine jackass-bin wineasio yabridge yabridgectl ];
in {
  environment.systemPackages = wineApps ++ (with pkgs; [ winetricks wine-run ]);

  services.udev.extraRules = ''
    KERNEL=="winesync", MODE="0644"
  '';

  boot.kernelModules = [ "winesync" ];
}
