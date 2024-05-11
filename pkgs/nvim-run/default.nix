{
  lib,
  pkgs,
  writeShellScript,
  runCommand,
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

  nvimCmd = writeShellScript "nvim-run" ''
    export PATH=$PATH:${PATH}
    exec -a nvim ${neovim}/bin/nvim "''${@}"
  '';
in
runCommand "nvim-run" { } ''
  mkdir -p $out/bin
  cp ${nvimCmd} $out/bin/nvim-run
  chmod +x $out/bin/nvim-run
''
