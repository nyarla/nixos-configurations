{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    shellAliases = {
      "docker" = "env DBUS_SESSION_BUS_ADDRESS= docker";
      "l" = "ls --color -F -la";
      "ls" = "ls --color -F";
      "nixos-apply" =
        ''sudo nixos-rebuild switch --flake "/etc/nixos#$(hostname)" ; sudo systemctl restart home-manager-$(id -n -u).service'';
      "nixos-build" = ''sudo nixos-rebuild build --flake "/etc/nixos/#$(hostname)"'';
      "nixos-upgrade" = ''sudo nixos-rebuild boot --flake "/etc/nixos#$(hostname)"'';
      "podman" = "env DBUS_SESSION_BUS_ADDRESS= podman";
      "waydroid" = "env XDG_DATA_HOME=/persist/home/nyarla/.local/share waydroid";
    };
    sessionVariables = {
      FAKE_RELEASE = 1;
      GOPATH = "$HOME/Applications/Development/go";
      NIXPKGS_ALLOW_UNFREE = 1;
      EDITOR = "nvim";
    };
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
    initExtraFirst = ''
      # enable home-manager
      export PATH=${
        lib.strings.concatStringsSep ":" [
          "$HOME/.nix-profile/bin"
          "$HOME/.local/bin"
          "$HOME/.fly/bin"
          "$GOPATH/bin"
          "$PATH"
        ]
      }

      # utility function
      function has() {
        type "''${1:-}" >/dev/null 2>&1
      }
    '';
    initExtra = ''
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt pushd_to_home
      setopt hist_ignore_all_dups
      setopt hist_reduce_blanks
      setopt hist_find_no_dups

      function nixos-clean() {
        sudo nix-collect-garbage --delete-older-than 7d
        sudo /run/current-system/bin/switch-to-configuration boot
      }

      if has fzy ; then
        function fzy-history() {
          BUFFER="$(fc -l -n 1 | sort -u | fzy --query "''${LBUFFER}")"
          CURSOR=$#BUFFER
          zle -R -c
        }

        zle -N fzy-history
        bindkey '^R' fzy-history
      fi

      if has wl-paste ; then
        function paste-clipboard() {
          BUFFER=$(wl-paste)
          CURSOR=$#BUFFER
          zle -R -c
        }

        zle -N paste-clipboard
        bindkey '^P' paste-clipboard
      fi

      unset -f has
    '';
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
