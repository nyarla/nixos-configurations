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
                "~/Applications/Programs/textlint/bin/*"
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
              lua5_1
              lua51Packages.luarocks
            ])
          )
        }:$PATH
      ''
      + extraInit;
    };

  nvim = mkWrappedApp "nvim" {
    paths = with pkgs; [
      # for files

      ## Bash
      shellcheck

      bash-language-server

      ## Dockerfile
      hadolint

      ## GitHub Actions
      actionlint
      ghalint
      zizmor

      ## Go
      go

      gofumpt
      gotools

      gopls

      ## JavaScript or TypeScript
      bun
      deno
      nodejs

      oxfmt

      oxlint

      typescript-language-server

      ## Lua
      stylua

      lua-language-server

      ## Nix
      nixfmt

      deadnix
      statix

      nixd

      ## Perl
      perlPackages.PerlTidy
      perlnavigator

      ## SQL
      sqlfluff

      sqls

      ## TOML
      taplo

      # for operations
      vscode-langservers-extracted
      gitFull
      hello
    ];
  };

  nvim-reconfigure = mkWrappedApp "nvim-reconfigure" {
    settings = {
      filesystem.allowWrite = [
        "~/.config/nvim"
        "~/.local/share/nvim"
      ];
      network.allowedDomains = [
        "github.com"
        "api.github.com"
        "codeload.github.com"
        "lfs.github.com"
        "objects.githubusercontent.com"
      ];
    };

    paths = with pkgs; [
      gitFull

      stylua
      lua-language-server
    ];
  };

  nvim-textern = mkWrappedApp "nvim-textern" {
    settings = {
      filesystem = {
        allowWrite = [
          "/run/user/1000/textern/**"
        ];
      };
    };
    extraInit = ''
      cd /run/user/1000/textern
    '';
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
