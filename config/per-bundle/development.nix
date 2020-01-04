{ config, pkgs, ... }:
{
  imports = [
    ../per-console/cloud.nix
    ../per-console/container.nix
    ../per-console/language.nix
    ../per-console/vcs.nix
    ../per-console/website.nix
  ];
}
