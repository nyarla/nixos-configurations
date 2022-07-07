_: {
  imports = [ ../config/tools/git.nix ];

  home.stateVersion =
    (import ../../system/config/nixos/version.nix).stateVersion;
}
