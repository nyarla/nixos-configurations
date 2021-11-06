{ config, pkgs, ... }: {
  imports = [
    ../per-console/archiver.nix
    ../per-console/backup.nix
    ../per-console/editor.nix
    ../per-console/fs.nix
    ../per-console/hardware.nix
    ../per-console/network.nix
    ../per-console/shell.nix

    ../per-service/nix-ld.nix
    ../per-service/dbus.nix
  ];
}
