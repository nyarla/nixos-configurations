{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    neovim-remote
    editorconfig-core-c

    nixfmt
    rnix-lsp
  ];

  services.dbus.packages = with pkgs; [ neovim neovim-remote ];
}
