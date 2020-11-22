{ ... }:
{
  imports = [
    # account
    ../config/per-account/nyarla.nix
    ../config/per-account/nyarla/development.nix

    # bundle
    ../config/per-bundle/development.nix
    ../config/per-bundle/shell.nix
    ../config/per-bundle/wsl2.nix

    # hardware
    ../config/per-hardware/tcp-bbr.nix

    # host
    ../config/per-host/WSL2.nix

    # location
    ../config/per-location/jp.nix

    # machine
    ../config/per-machine/WSL2.nix

    # service
    ../config/per-service/docker.nix
    ../config/per-service/nixpkgs.nix
  ];
}
