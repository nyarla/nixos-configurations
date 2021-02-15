{ config, pkgs, ... }: {
  imports = [
    ../per-console/archiver.nix
    ../per-console/backup.nix
    ../per-console/editor.nix
    ../per-console/fs.nix
    ../per-console/network.nix
    ../per-console/shell.nix
    ../../external/nix-ld/modules/nix-ld.nix
  ];
}
