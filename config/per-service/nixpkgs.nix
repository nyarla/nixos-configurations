{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.overlays = [ (import ../../external/dotnix/pkgs.nix) ];
}
