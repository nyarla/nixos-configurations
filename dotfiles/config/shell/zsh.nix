{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    shellAliases = {
      "cd" = "__cd";
      "ls" = "ls --color -F";
      "l" = "ls --color -F -la";
      "lefthook-install" =
        "cp $HOME/local/githooks/lefthook.yml . && cp -R $HOME/local/githooks/.lefthook . && lefthook install -f";
      "nvim-resume" = "pkill -SIGCONT nvim";
      "rm" = "trash";
      "nixos-upgrade" =
        ''sudo nixos-rebuild boot --flake "/etc/nixos#$(hostname)"'';
      "nixos-apply" =
        ''sudo nixos-rebuild switch --flake "/etc/nixos#$(hostname)"'';
      "nixos-build" =
        ''sudo nixos-rebuild build --flake "/etc/nixos/#$(hostname)"'';
    };
    sessionVariables = {
      FAKE_RELEASE = 1;
      GOPATH = "$HOME/dev";
      NIXPKGS_ALLOW_UNFREE = 1;
    };
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignorePatterns = [ ];
      ignoreDups = true;
      share = true;
    };
    plugins = [{
      name = "z";
      file = "z.sh";
      src = pkgs.fetchFromGitHub {
        owner = "rupa";
        repo = "z";
        rev = "b82ac78a2d4457d2ca09973332638f123f065fd1";
        sha256 = "sha256-4jMHh1GVRdFNjUjiPH94vewbfLcah7Agu153zjVNE14=";
      };
    }];
    initExtraFirst = ''
      # enable home-manager
      export PATH=${
        lib.strings.concatStringsSep ":" [
          "$HOME/local/textlintrc/node_modules/.bin"
          "$HOME/.local/share/npm/bin"
          "$HOME/.local/bin"
          "$HOME/dev/bin"
          "$HOME/local/bin"
          "$PATH"
        ]
      }
      export EDITOR=nvim

      # import nix-ld
      if test -e /etc/profile.d/nix-ld ; then
        source /etc/profile.d/nix-ld
      fi

      # change cursor to underline
      echo -en '\033[3 q'

      # utility function
      function has() {
        type "''${1:-}" >/dev/null 2>&1
      }
    '';
    initExtraBeforeCompInit = ''
      if has perl && test -d $HOME/.local/share/perl ; then
        eval "$(perl -I"$HOME"/.local/share/perl/lib/perl5 -Mlocal::lib="$HOME"/.local/share/perl)"
        export PERL_CPANM_OPT="--local-lib-contained $HOME/.local/share/perl"
      fi

      if test -e $HOME/.cargo/env ; then
        source $HOME/.cargo/env
      fi
    '';
    initExtra = ''
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt pushd_to_home
      setopt hist_ignore_all_dups
      setopt hist_reduce_blanks
      setopt hist_find_no_dups

      function nix-clean() {
        nix-store --gc
        sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +14
        sudo nix-store --optimize --verbose
        sudo /run/current-system/bin/switch-to-configuration boot
      }

      function nix-clean-all() {
        nix-store --gc
        sudo nix-store --gc
        sudo nix-collect-garbage -d
        sudo nix-store --optimize --verbose
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

      function __cd() {
        local dir=''${1:-}

        if test  "x''${dir}" = "x" ; then
          local dir=$(z -l | sed 's/ \+/ /g' | cut -d\   -f2 | fzy | sed "s!~!$HOME!")
          z --add "''${dir}"
          \cd "''${dir}"
        else
          z --add "''${dir}"
          \cd "''${dir}"
        fi
      }

      function minil-release() {
        if type lefthook >/dev/null 2>&1 ; then
          lefthook uninstall
        fi

        FAKE_RELEASE= minil release

        if type lefthook >/dev/null 2>&1 ; then
          cp $HOME/local/githooks/lefthook.yml . \
          && cp -R $HOME/local/githooks/.lethook . \
          && lefthook install
        fi
      }

      compdef __cd=cd

      unset -f has
    '';
  };

  home.packages = with pkgs; [
    fzy

    file
    gawk
    gnumake
    gnused

    inotify-tools
    trash-cli

    keychain
    mosh

    bc
    tree
  ];
}
