{ config, pkgs, ... }:
{
  imports = [
    ../per-console/archive.nix
    ../per-console/editor.nix
    ../per-console/files.nix
    ../per-console/fs.nix
    ../per-console/network.nix
    ../per-console/shell.nix
    ../per-console/system.nix
  ];
}
