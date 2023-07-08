_: {
  imports = [
    ../config/app/appimage.nix
    ../config/app/browser.nix
    ../config/app/multimedia.nix
    ../config/app/office.nix
    ../config/app/weston.nix
    ../config/files/alsa.nix
    ../config/files/skk.nix
    ../config/nixos/gsettings.nix
    ../config/services/dunst.nix
    ../config/services/gnome-keyring.nix
    ../config/services/keychain.nix
    ../config/services/polkit.nix
    ../config/services/syncthing.nix
    ../config/shell/starship.nix
    ../config/shell/zsh.nix
    ../config/tools/archiver.nix
    ../config/tools/development.nix

    ../app/git
    ../app/openbox
  ];

  # More customizations
  # ===================

  # Development
  # -----------

  # git
  programs.git.userName = "nyarla";
  programs.git.userEmail = "nyarla@kalaclista.com";

  # keychain (ssh)
  programs.keychain.keys = [ "id_ed25519" ];

  # System configuration
  # ====================

  # home-manager
  # -------------
  programs.home-manager.enable = true;

  # stateVersion (same as NixOS)
  home.stateVersion =
    (import ../../system/config/nixos/version.nix).stateVersion;
}
