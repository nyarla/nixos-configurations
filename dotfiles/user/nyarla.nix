_: {
  imports = [
    ../config/app/appimage.nix
    ../config/tools/archiver.nix
    ../config/tools/git.nix
  ];

  home.stateVersion =
    (import ../../system/config/nixos/version.nix).stateVersion;
}
