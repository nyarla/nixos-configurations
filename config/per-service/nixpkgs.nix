{ config, pkgs, ...}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ../../overlays/extended/default.nix)
    (import ../../overlays/modified/default.nix)
    (import ../../overlays/workaround/default.nix)
  ];
}
