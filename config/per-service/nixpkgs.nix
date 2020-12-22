{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.overlays = [
    (import ../../overlays/extended/default.nix)
    (import ../../overlays/modified/default.nix)
    (import ../../overlays/workaround/default.nix)
  ];

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.0.2u" "p7zip-16.02" ];
}
