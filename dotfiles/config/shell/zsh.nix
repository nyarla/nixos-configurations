{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    shellAliases = {
      "cd" = "__cd";
      "edit" = "make -f ~/.config/nvim/Makefile edit";
      "l" = "ls --color -F -la";
      "ls" = "ls --color -F";
      "nixos-apply" =
        ''sudo nixos-rebuild switch --flake "/etc/nixos#$(hostname)"'';
      "nixos-build" =
        ''sudo nixos-rebuild build --flake "/etc/nixos/#$(hostname)"'';
      "nixos-upgrade" =
        ''sudo nixos-rebuild boot --flake "/etc/nixos#$(hostname)"'';
      "nvim-resume" = "pkill -SIGCONT nvim";
      "rm" = "trash";
      "waydroid" =
        "env XDG_DATA_HOME=/persist/home/nyarla/.local/share waydroid";
    };
    sessionVariables = {
      FAKE_RELEASE = 1;
      GOPATH = "$HOME/Applications/Development/go";
      NIXPKGS_ALLOW_UNFREE = 1;
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
          "$HOME/.local/bin"
          "$HOME/.fly/bin"
          "$HOME/.local/share/npm/bin"
          "$GOPATH/bin"
          "$PATH"
        ]
      }
      export EDITOR=nvim
      export NVIM_USE_TABNINE=1

      # utility function
      function has() {
        type "''${1:-}" >/dev/null 2>&1
      }
    '';
    initExtraBeforeCompInit = ''
      if has perl ; then
        eval "$(perl -I${pkgs.perlPackages.locallib}/lib/perl5/site_perl/${pkgs.perl.version} -Mlocal::lib=$HOME/.local/share/perl/global)"
        export PERL_CPANM_OPT="--local-lib-contained $HOME/.local/share/perl/global"
        export PERL_CPANM_HOME=$HOME/.local/share/perl/cpanm
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

        if test ! -s ~/.z ; then
          z --add /etc/nixos
          z --add $HOME/Development/kalaclista-social
          z --add $HOME/Programming/the.kalaclista.com

          for d in $(\ls ~/); do
            z --add "''${HOME}/''${d}"
          done
        fi

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
        touch .git/hooks/.disable-commitlint
        touch .git/hooks/.disable-textlint

        FAKE_RELEASE= minil release

        rm .git/hooks/.disable-commitlint
        rm .git/hooks/.disable-textlint
      }

      compdef __cd=cd

      unset -f has
    '';
  };

  home.packages = with pkgs; [
    fzy
    platinum-searcher
    mmv-go

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
