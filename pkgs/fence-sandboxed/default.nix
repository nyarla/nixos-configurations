{
  lib,
  writeShellScriptBin,
  writeText,
  symlinkJoin,

  fence,
  pkgs,
}:
let
  mkFencedApplication =
    {
      name,
      settings ? null,
      command,
      extraInit ? "",
    }:
    let
      settingsJSON =
        if settings != null then (writeText "${name}-settings.json" (builtins.toJSON settings)) else "";
    in
    writeShellScriptBin name ''
      set -euo pipefail

      settingsJSON() {
        local cwd
        cwd="$(pwd)"
        if [[ -e "${settingsJSON}" ]]; then
          echo "${settingsJSON}"
          return 0
        fi

        if [[ -e "''${cwd}/.fence/${name}.json" ]]; then
          echo "''${cwd}/.fence/${name}.json"
          return 0
        fi

        if [[ -e "$HOME/.config/fence/${name}.json" ]]; then
          echo "$HOME/.config/fence/${name}.json"
          return 0
        fi

        echo ""
        return 0
      }

      main() {
        local settingsJSON=""
        settingsJSON="$(settingsJSON)"

        local settingsArg=""
        if [[ -e "''${settingsJSON}" ]]; then
          settingsArg="--settings ''${settingsJSON}"
        fi

        exec ${lib.getExe fence} $settingsArg -- ${command} "''${@:-}"
      }

      ${extraInit}

      main "''${@:-}"
    '';

  apps = {
    # git
    git = mkFencedApplication {
      name = "sgit";
      command = ''env GIT_SSH_COMMAND='ssh -F /dev/null -o "ProxyCommand=nc -X 5 -x 127.0.0.1:1080 %h %p"' ${pkgs.gitFull}/bin/git '';
      extraInit = ''
        export PATH=$PATH:${pkgs.gitFull}/bin
      '';
    };

    # nvim
    nvim-reconfigure = mkFencedApplication {
      name = "nvim-reconfigure";
      command = "env XDG_RUNTIME_DIR=/run/user/$(id -u) ${pkgs.neovim}/bin/nvim";
      settings = {
        extends = "@base";
        filesystem = {
          allowRead = [
            "~/.config/git/"
          ];
          allowWrite = [
            "~/.cache/nvim/"
            "~/.config/nvim"
            "~/.local/share/nvim/"
            "~/.local/state/nvim/"
          ];
          allowUnixSockets = [
            "/run/user/*/wayland-0"
            "/run/user/*/wayland-0.lock"
          ];
          defaultDenyRead = true;
        };
        network = {
          allowedDomains = [
            "github.com"
            "api.github.com"
            "codeload.github.com"
            "lfs.github.com"
            "objects.githubusercontent.com"
          ];
        };
      };
      extraInit =
        let
          PATH = lib.makeBinPath (
            with pkgs;
            [
              gitFull
              lua-language-server
            ]
          );
        in
        ''
          export PATH=$PATH:${PATH}
          export XDG_RUNTIME_DIR=/run/user/$(id -u)
        '';
    };

    nvim = mkFencedApplication {
      name = "nvim";
      command = "env XDG_RUNTIME_DIR=/run/user/$(id -u) ${pkgs.neovim}/bin/nvim";
      settings = {
        extends = "@base";
        filesystem = {
          allowGitConfig = true;
          allowRead = [
            "~/.config/git/"
            "~/.config/nvim/"
            "~/.local/share/nvim/"
          ];
          allowWrite = [
            "."
            "~/.cache/nvim/"
            "~/.local/share/nvim/neo-tree.nvim.log"
            "~/.local/state/nvim/"
          ];
          allowUnixSockets = [
            "/run/user/*/wayland-0"
            "/run/user/*/wayland-0.lock"
          ];
          defaultDenyRead = true;
        };
      };
      extraInit =
        let
          PATH = lib.makeBinPath (
            with pkgs;
            [
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
              go
              gotools
              nixfmt
              perlPackages.PerlTidy
              prettier
              stylua

              # language-server
              bash-language-server
              gopls
              lua-language-server
              nixd
              perlnavigator
              sqls
              taplo
              typescript-language-server
              vscode-langservers-extracted

              # AIO toolchain
              biome
              deno
              sqlfluff

              # for testing
              hello
            ]
          );
        in
        ''
          export PATH=$PATH:${PATH}
        '';
    };
  };
in
symlinkJoin {
  name = "fence-sandboxed-commands";
  paths = with apps; [
    git

    nvim
    nvim-reconfigure
  ];
}
