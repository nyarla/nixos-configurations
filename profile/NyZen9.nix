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
    ../config/per-toolchain/editor.nix
    ../config/per-toolchain/fs.nix
    ../config/per-toolchain/hardware.nix
    ../config/per-toolchain/network.nix
    ../config/per-service/android.nix

    ../config/per-service/dbus.nix
    ../config/per-service/nix-ld.nix

    ../config/per-location/jp.nix

    # desktop
    ../config/per-service/daw.nix
    ../config/per-service/file-manager.nix
    ../config/per-service/multimedia.nix
    ../config/per-service/office.nix
    ../config/per-service/terminal.nix
    ../config/per-service/wine.nix

    ../config/per-service/mining.nix

    # desktop environment
    #../config/per-service/labwc.nix
    ../config/per-service/xorg.nix
    ../config/per-service/uim.nix

    # host
    ../config/per-host/NyZen9.nix

    # services
    ../config/per-service/webapp.nix

    # temporary
    ../config/per-service/patch.nix
  ];
}
