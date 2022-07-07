_: {
  imports = [
    ../config/app/appimage.nix
    ../config/app/browser.nix
    ../config/services/dunst.nix
    ../config/services/syncthing.nix
    ../config/app/chat.nix
    ../config/shell/starship.nix
    ../config/shell/zsh.nix
    ../config/tools/archiver.nix
    ../config/tools/development.nix
    ../config/tools/git.nix
  ];

  home.stateVersion =
    (import ../../system/config/nixos/version.nix).stateVersion;
}
