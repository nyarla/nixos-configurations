self: super: let
  require = path: args: super.callPackage (import path) args ;
in {
  airwave = require ./pkgs/airwave/default.nix { };

  aseprite = super.aseprite.override {
    unfree = true;
  };

  calibre = super.calibre.overrideAttrs (old: rec {
    version = "4.13.0";
    src     = super.fetchurl {
      url = "https://github.com/kovidgoyal/calibre/releases/download/v4.13.0/calibre-4.13.0.tar.xz";
      sha256 = "1xp1fvpdizk6g74diam4nd59s6fhcvp086y1brm6r9wy9zm7sn7r";
    };
    buildInputs = old.buildInputs ++ [ super.hyphen super.hunspell super.python2Packages.pyqtwebengine ];
  });

  carla = require ./pkgs/carla/default.nix { };

  fbterm = super.fbterm.overrideAttrs (old: rec {
    patches = [
      ./pkgs/fbterm/color.patch
    ];
  });

  ibus-skk = require ./pkgs/ibus-skk/default.nix { }; 

  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ self.uim super.dbus ];
    configureFlags = old.configureFlags ++ [
      "--enable-uim"
    ];

    # patches = [
    #   ./pkgs/mlterm/remove-workaround-for-lxqt.patch
    # ];

  });

  run-scaled = super.run-scaled.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's!attach "$DISPLAYNUM"!attach socket:///run/user/$(id -u)/xpra/$(hostname)-''${DISPLAYNUM#:}!' run_scaled
    '';
  });

  tmux = super.tmux.overrideAttrs (old: rec {
    patches = [
      (super.fetchurl {
        url     = "https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-2.9a-fix.diff";
        sha256  = "11siyirp9wlyqq9ga4iwxw6cb4zg5n58jklgab2dkp469wxbx2ql";
      })
    ];
  });
  
  virtualbox = super.virtualbox.overrideAttrs (old: rec {
    version = "6.1.6";
    src = super.fetchurl {
      url = "https://download.virtualbox.org/virtualbox/${version}/VirtualBox-${version}.tar.bz2";
      sha256 = "b031c30d770f28c5f884071ad933e8c1f83e65b93aaba03a4012077c1d90a54f";
    };
  });

  virtualboxExtpack = let
    version = "6.1.6";
  in super.fetchurl rec {
    name = "Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack";
    url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
    sha256 = "80b96b4b51a502141f6a8981f1493ade08a00762622c39e48319e5b122119bf3";
  };
  xpra = require ./pkgs/xpra/default.nix { };
}
