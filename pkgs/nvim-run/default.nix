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
      deadnix
      hadolint
      shellcheck
      statix

      # formatter
      go
      gotools
      nixfmt-rfc-style
      nodePackages.prettier
      perlPackages.PerlTidy
      stylua

      # language server
      gopls
      lua-language-server
      nixd
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      perlnavigator
      sqls
      tailwindcss-language-server
      taplo

      # all-in-one toolchains
      biome
      deno
      sqlfluff

      # for test
      hello
    ]
  );
in
writeShellScriptBin "nvim-run" ''
  export PATH=$PATH:${PATH}
  exec -a nvim ${neovim}/bin/nvim "''${@}"
''
