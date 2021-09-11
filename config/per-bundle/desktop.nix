{ config, pkgs, ... }: {
  imports = [
    # applications
    ../per-desktop/browser.nix
    ../per-desktop/file-manager.nix
    ../per-desktop/multimedia.nix
    ../per-desktop/office.nix
    ../per-desktop/terminal.nix
    ../per-desktop/wine.nix

    # desktop
    ../per-desktop/openbox.nix

    # input method
    ../per-desktop/ibus.nix
  ];
}
