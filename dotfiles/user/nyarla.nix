_: {
  imports = [
    ../config/app/browser.nix
    ../config/app/chat.nix
    ../config/app/creative.nix
    ../config/app/multimedia.nix
    ../config/app/office.nix
    ../config/app/wine.nix
    ../config/desktop/theme.nix
    ../config/files/skk.nix
    ../config/nixos/gsettings.nix
    ../config/services/polkit.nix
    ../config/services/syncthing.nix
    ../config/shell/starship.nix
    ../config/shell/zsh.nix
    ../config/tools/archiver.nix
    ../config/tools/development.nix

    ../app/git
    ../app/labwc
    ../app/mlterm
    ../app/xdg
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
  systemd.user.startServices = "sd-switch";

  # stateVersion (same as NixOS)
  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
}
