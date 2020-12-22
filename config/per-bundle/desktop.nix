{ config, pkgs, ... }: {
  imports = [
    ../per-desktop/browser.nix
    ../per-desktop/jwm.nix
    ../per-desktop/files.nix
    ../per-desktop/fonts.nix
    ../per-desktop/media.nix
    ../per-desktop/network.nix
    ../per-desktop/office.nix
    ../per-desktop/polkit.nix
    ../per-desktop/system.nix
    ../per-desktop/theme.nix
    ../per-desktop/uim.nix
    ../per-desktop/utils.nix
    ../per-desktop/wine.nix
    ../per-desktop/xnest.nix
    ../per-desktop/xorg.nix
  ];
}
