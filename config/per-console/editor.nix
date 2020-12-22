{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    editorconfig-core-c

    nixfmt
    rnix-lsp
  ];

  services.dbus.packages = with pkgs; [ neovim ];
}
