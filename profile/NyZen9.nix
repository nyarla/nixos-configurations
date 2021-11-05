{ pkgs, ... }: {
  imports = [
    # nixpkgs
    ../config/per-service/nixpkgs.nix

    # account
    ../config/per-account/nyarla.nix
    ../config/per-account/nyarla/desktop.nix
    ../config/per-account/nyarla/development.nix
    ../config/per-account/nyarla/vm.nix

    # bundle
    ../config/per-bundle/desktop.nix
    ../config/per-bundle/development.nix
    ../config/per-bundle/shell.nix

    # software
    ../config/per-desktop/coin.nix
    ../config/per-desktop/daw.nix

    # location
    ../config/per-location/jp.nix

    # host
    ../config/per-host/NyZen9.nix

    # hardware
    ../config/per-machine/NyZen9.nix
  ];
}
