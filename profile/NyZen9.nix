{ pkgs, ... }: {
  imports = [
    # system (wip: migration)
    ../system/profile/NyZen9.nix

    # nixpkgs
    ../config/per-service/nixpkgs.nix

    # system
    ../config/per-service/android.nix

    ../config/per-service/dbus.nix

    # desktop
    ../config/per-service/daw.nix
    ../config/per-service/files.nix
    ../config/per-service/terminal.nix

    # desktop environment
    ../config/per-service/wayland.nix
    ../config/per-service/xorg.nix
    ../config/per-service/fcitx.nix

    # host
    ../config/per-host/NyZen9.nix

    # services
    ../config/per-service/webapp.nix

    # temporary
    ../config/per-service/patch.nix
  ];
}
