{ config, pkgs, ... }: {
  imports = [
    ../per-console/cloud-toolchain.nix
    ../per-console/container-toolchain.nix
    ../per-console/development.nix
    ../per-console/vcs.nix
    ../per-console/website.nix
  ];
}
