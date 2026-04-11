{
  lib,
  pkgs,
  writeShellScriptBin,
  neovim,
}:
let
  PATH = lib.makeBinPath (
    with pkgs;
    [
      # linter
      actionlint
      deadnix
      hadolint
      shellcheck
      statix

      # formatter
      go
      gotools
      nixfmt
      perlPackages.PerlTidy
      prettier
      stylua

      # language server
      bash-language-server
      gopls
      lua-language-server
      nixd
      perlnavigator
      sqls
      tailwindcss-language-server
      taplo
      typescript-language-server
      vscode-langservers-extracted

      # all-in-one toolchains
      biome
      deno
      sqlfluff

      # for test
      hello
    ]
  );
in
writeShellScriptBin "nvim" ''
  export PATH=$PATH:${PATH}

  if [[ -e $HOME/.config/llm/env ]]; then
    eval "$(cat $HOME/.config/llm/env)"
  fi

  exec -a nvim ${neovim}/bin/nvim "''${@}"
''
