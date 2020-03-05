self: super: let
  require = path: args: super.callPackage (import path) args ;
in {
  airwave = require ./pkgs/airwave/default.nix { };

  aseprite = super.aseprite.override {
    unfree = true;
  };

  calibre = super.calibre.overrideAttrs (old: rec {
    version = "4.8.0";
    src     = super.fetchurl {
      url = "https://github.com/kovidgoyal/calibre/releases/download/v4.8.0/calibre-4.8.0.tar.xz";
      sha256 = "1lk44qh3hzqhpz2b00iik7cgjg4xm36qjh2pxflkjnbk691gbpqk";
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
    buildInputs = old.buildInputs ++ [ self.ibus super.dbus ];
    configureFlags = old.configureFlags ++ [
      "--enable-ibus"
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
  
  xpra = require ./pkgs/xpra/default.nix { };
}
