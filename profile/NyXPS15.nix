{ ... }: {
  imports = [
    ../config/per-service/nixpkgs.nix

    ../config/per-account/nyarla.nix

    ../config/per-bundle/desktop.nix
    ../config/per-bundle/development.nix
    ../config/per-bundle/shell.nix

    ../config/per-desktop/bitwig.nix
    ../config/per-desktop/hidpi.nix
    ../config/per-desktop/virtualbox.nix

    ../config/per-location/jp.nix

    ../config/per-machine/NyXPS15.nix
  ];
}
