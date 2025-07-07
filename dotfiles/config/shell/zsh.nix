{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;

    # completion
    enableCompletion = true;
    autocd = true;

    # highlight
    syntaxHighlighting.enable = true;

    # zshrc
    initContent =
      let
        PATH = lib.strings.concatStringsSep ":" [
          "$HOME/.nix-profile/bin"
          "$HOME/.local/bin"
          "$GOPATH/bin"
          "$PATH"
        ];

        options = lib.mkOrder 500 ''
          export PATH=${PATH}

          setopt auto_pushd
          setopt pushd_ignore_dups
          setopt pushd_to_home

          setopt hist_ignore_all_dups
          setopt hist_reduce_blanks
          setopt hist_find_no_dups
        '';

        functions = lib.mkOrder 551 ''
          function has() {
            type "''${1:-}" >/dev/null 2>&1
          }

          function nixos-clean() {
            sudo nix-collect-garbage --delete-older-than 7d
            sudo /run/current-system/bin/switch-to-configuration boot
          }

          if has fzy ; then
            function __bind-history() {
              BUFFER="$(fc -l -n 1 | sort -u | fzy --query "''${LBUFFER}")"
              CURSOR=$#BUFFER
              zle -R -c
            }

            zle -N __bind-history
            bindkey '^R' __bind-history 
          fi

          if has wl-paste ; then
            function __bind-clipboard() {
              BUFFER=$(wl-paste)
              CURSOR=$#BUFFER
              zle -R -c
            }

            zle -N __bind-clipboard
            bindkey '^P' __bind-clipboard
          fi
        '';
      in
      lib.mkMerge [
        options
        functions
      ];

    # aliases
    shellAliases =
      let
        podman = "env DBUS_SESSION_BUS_ADDRESS= podman";
        ls = "ls --color -F";
        nixos-rebuild = action: "sudo nixos-rebuild ${action} --flake /etc/nixos#$(hostname)";
      in
      {
        inherit ls;
        l = "${ls} -l";

        docker = podman;
        inherit podman;

        nixos-apply = "${nixos-rebuild "apply"} && sudo systemctl restart home-manager-$(id -n -u).service";
        nixos-build = nixos-rebuild "build";
        nixos-upgrade = nixos-rebuild "boot";

        waydroid = "env env XDG_DATA_HOME=/persist/home/nyarla/.local/share waydroid";
      };
    sessionVariables = {
      # editor
      EDITOR = "nvim";

      # development
      GOPATH = "$HOME/Applications/Development/go";
      FAKE_RELEASE = 1;

      # nixpkgs
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignorePatterns = [ ];
      ignoreDups = true;
      share = true;
    };

    plugins = [
      {
        name = "enhancd";
        file = "init.sh";
        src = pkgs.fetchFromGitHub {
          owner = "babarot";
          repo = "enhancd";
          rev = "5afb4eb6ba36c15821de6e39c0a7bb9d6b0ba415";
          hash = "sha256-pKQbwiqE0KdmRDbHQcW18WfxyJSsKfymWt/TboY2iic=";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    fzy
    mmv-go
    ripgrep
    tmux
    wcwidth-cjk

    file
    gawk
    gnumake
    gnused

    inotify-tools

    keychain

    bc
    tree
  ];
}
