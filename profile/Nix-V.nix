{ pkgs, ... }: {
  imports = [
    ../config/per-account/nyarla.nix
    ../config/per-account/nyarla/development.nix

    ../config/per-bundle/development.nix
    ../config/per-bundle/shell.nix

    ../config/per-hardware/tcp-bbr.nix

    ../config/per-host/Nix-V.nix

    ../config/per-location/jp.nix

    ../config/per-machine/Hyper-V.nix

    ../config/per-service/docker.nix
    ../config/per-service/nix-ld.nix
    ../config/per-service/nixpkgs.nix
    ../config/per-service/tailscale.nix

    ../config/per-overrides/Nix-V.nix
  ];

  environment.systemPackages = with pkgs; [ neovim ];
}
