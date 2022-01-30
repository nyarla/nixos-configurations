{ pkgs, ... }: {
  imports = [
    # nixpkgs
    ../config/per-service/nixpkgs.nix

    # hardware
    ../config/per-machine/NyZen9.nix

    # account
    ../config/per-account/nyarla.nix
    ../config/per-account/nyarla/desktop.nix
    ../config/per-account/nyarla/development.nix
    ../config/per-account/nyarla/vm.nix

    # system
    ../config/per-console/fs.nix
    ../config/per-console/hardware.nix
    ../config/per-console/network.nix

    ../config/per-service/dbus.nix
    ../config/per-service/nix-ld.nix

    ../config/per-location/jp.nix

    # ---

    # desktop
    ../config/per-bundle/desktop.nix

    # software
    ../config/per-desktop/coin.nix
    ../config/per-desktop/daw.nix

    # host
    ../config/per-host/NyZen9.nix

  ];
}
