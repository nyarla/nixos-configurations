{
  callPackage,
  symlinkJoin,

  lib,
  pkgs,

  neovim,
}:
let
  mkWrappedApp =
    name:
    {
      settings ? { },
      extraInit ? "",
      paths ? [ ],
    }:
    callPackage ./wrapper.nix {
      inherit name;
      appname = "nvim";
      cmd = "env XDG_RUNTIME_DIR=/run/user/$(id -u) ${neovim}/bin/nvim";
      settings =
        let
          deepMerge =
            sets:
            lib.zipAttrsWith (
              _: values:
              if lib.all lib.isAttrs values then
                deepMerge values
              else if lib.all lib.isList values then
                lib.concatLists values
              else
                lib.last values
            ) sets;
        in
        deepMerge [
          {
            extends = "@base";
            filesystem = {
              allowGitConfig = true;
              allowRead = [
                "~/.config/git/"
                "~/.config/nvim/"
                "~/.local/share/nvim/"
                "~/Applications/Programs/textlint"
              ];
              allowExecute = [
                "~/Applications/Programs/textlint/bin"
              ];
              allowWrite = [
                "."
                "~/.cache/nvim/"
                "~/.cache/go-build"
                "~/.local/share/nvim/neo-tree.nvim.log"
                "~/.local/state/nvim/"
              ];
              allowUnixSockets = [
                "/run/user/*/wayland-0"
                "/run/user/*/wayland-0.lock"
              ];
              defaultDenyRead = true;
            };
          }
          settings
        ];

      extraInit = ''
        if [[ ! -e $HOME/.local/state/nvim ]]; then
          mkdir -p $HOME/.local/state/nvim
        fi

        export PATH=${
          lib.makeBinPath (
            paths
            ++ (with pkgs; [
              gitFull
              nodejs
            ])
          )
        }:$PATH
      ''
      + extraInit;
    };

  nvim = mkWrappedApp "nvim" {
    paths = with pkgs; [
      # runtime or compiler
      bun
      deno
      go
      nodejs

      # git
      gitFull

      # linter
      actionlint
      ghalint
      zizmor

      deadnix
      statix

      hadolint
      shellcheck

      # formatter
      biome
      gofumpt
      gotools
      nixfmt
      perlPackages.PerlTidy
      prettier
      sqlfluff
      stylua

      # language server
      bash-language-server
      gopls
      lua-language-server
      lua-language-server
      nixd
      perlnavigator
      sqls
      taplo
      typescript-language-server
      vscode-langservers-extracted

      # for testing
      hello
    ];
  };

  nvim-reconfigure = mkWrappedApp "nvim-reconfigure" {
    settings = {
      allowWrite = [ "~/.config/nvim" ];
      network = {
        allowHosts = [
          "github.com"
          "api.github.com"
          "codeload.github.com"
          "lfs.github.com"
          "objects.githubusercontent.com"
        ];
      };
    };

    paths = with pkgs; [
      gitFull

      stylua
      lua-language-server
    ];
  };

  nvim-textern = mkWrappedApp "nvim-textern" {
    settings = {
      allowWrite = [
        "/run/user/1000/textern/**"
      ];
    };
  };
in
symlinkJoin {
  name = "nvim";
  paths = [
    nvim
    nvim-reconfigure
    nvim-textern
  ];
}
