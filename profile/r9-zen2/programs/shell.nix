{ lib, pkgs, ... }: {
  mod.security.sandbox.shell = {
    extraPackages = with pkgs; [
      fzy
      starship
      zsh

      actionlint
      ghalint
      shellcheck
      zizmor

      bash-language-server
      tailwindcss-language-server
    ];

    features = {
      gnupg.enable = true;
      neovim.enable = true;
      pi-coding-agent.enable = true;
      proton-pass-cli.enable = true;
    };

    settings = {
      mounts.rw = [ "/home/nyarla/Programming" ];
      dotfiles =
        let
          file = path: { "/etc/nixos/files/shellbox/${path}" = "/home/nyarla/${path}"; };
        in
        lib.attrsets.mergeAttrsList (
          lib.lists.forEach [
            ".config/git/config"
            ".config/git/ignore"
            ".config/herdr/config.toml"
            ".config/starship.toml"
            ".zshrc"
          ] file
        );
    };
  };

  mod.sandbox.shell.rust-desktop = {
    enable = true;
    dotDir = "/home/nyarla/Applications/Development/Rust";
  };

  mod.sandbox.shell.typescript = {
    enable = true;
    ports = [ 1313 ];
  };
}
