{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    editorconfig-core-c

    nixpkgs-fmt
    rnix-lsp
  ];

  services.dbus.packages = with pkgs; [
    neovim
  ];
}
