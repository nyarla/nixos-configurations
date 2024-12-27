self: super:
let
  require = path: super.callPackage (import path);
in
{
  # additional packages
  aria-misskey = require ./aria-misskey { };
  audiogridder = require ./audiogridder { };
  cskk = require ./cskk { };
  cuda-shell = require ./cuda-shell {
    cudaPackages = super.cudaPackages_11_8;
    nvidia_x11 = null;
  };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = super.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt5 = super.libsForQt5.callPackage (import ./fcitx5-cskk) { enableQt = true; };
  fcitx5-cskk-qt6 = super.kdePackages.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = true;
  };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  ildaeil = require ./ildaeil {
    inherit (self) carla;
    wine = self.wineUsingFull;
  };
  kaunas = require ./kaunas { };
  nvim-run = require ./nvim-run { };
  openjtalk = require ./openjtalk { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  shoreman = require ./shoreman { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  stability-matrix = require ./stability-matrix { };
  wine-run = require ./wine-run { };
  wine-vst-wrapper = require ./wine-vst-wrapper { };
  wineasio = require ./wineasio { wine = self.wineUsingFull; };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # modified packages
  bitwig-sutido3 = super.bitwig-sutido3.overrideAttrs (old: rec {
    version = "3.3.11";
    src = super.fetchurl {
      url = "https://downloads.bitwig.com/stable/${version}/${old.pname}-${version}.deb";
      sha256 = "137i7zqazc2kj40rg6fl6sbkz7kjbkhzdd7550fabl6cz1a20pvh";
    };
  });

  calibre = super.calibre.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ super.python3Packages.pycrypto ];
    disabledTests = [ "test_fts_search" ];
  });

  carla = require ./carla {
    inherit (super) carla;
    wine = self.wineUsingFull;
  };

  firefox-bin-unwrapped = super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  flaresolverr = require ./flaresolverr-21hsmw { };

  labwc = super.labwc.overrideAttrs (_: {
    patches = [
      (super.fetchpatch {
        name = "text-input-v1.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-IME-support-text-input-v1.patch?h=labwc-im&id=54103c35c0e8859317e7455204d78fb606c494f9";
        hash = "sha256-WJnbd6DXSYSccvyLiLIswpC3uBzsvGZ4BX8mxUl2b7Q=";
      })
    ];
  });

  looking-glass-client = super.looking-glass-client.overrideAttrs (_: {
    version = "bleeding-edge";
    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "e25492a3a36f7e1fde6e3c3014620525a712a64a";
      hash = "sha256-DBmCJRlB7KzbWXZqKA0X4VTpe+DhhYG5uoxsblPXVzg=";
      fetchSubmodules = true;
    };
    patches = [ ];
  });

  speechd-with-openjtalk = super.speechd.overrideAttrs (old: rec {
    src = super.fetchurl {
      url = "https://github.com/brailcom/speechd/releases/download/0.12.0-rc3/speech-dispatcher-0.12.0-rc3.tar.gz";
      hash = "sha256-vStiv9z3RVKs2F6dpOQv0f8SuOoYYQpqG9aDXfdntmM=";
    };
    buildInputs = old.buildInputs ++ [ self.openjtalk ];
    configureFlags = old.configureFlags ++ [ "--with-openjtalk" ];
  });

  thunderbird-bin-unwrapped = super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tmux = super.tmux.overrideAttrs (old: rec {
    patches = [
      ../patches/tmux-3.5-fix.diff
    ];
  });

  # wineUsingFull = super.lib.overrideDerivation super.wineWowPackages.stagingFull (old: rec {
  #   buildInputs =
  #     old.buildInputs
  #     ++ (with super; [
  #       libgcrypt.dev
  #       libva.dev
  #     ])
  #     ++ (with super.pkgsi686Linux; [
  #       libgcrypt.dev
  #       libva.dev
  #     ]);

  #   configureFlags = old.configureFlags ++ [
  #     "--with-va"
  #     "--with-gcrypt"
  #     "--disable-test"
  #   ];
  # });
  wineUsingFull = super.wineWowPackages.stagingFull;

  yabridge = super.yabridge.override { wine = self.wineUsingFull; };
  yabridtctl = super.yabridgectl.override {
    inherit (self) yabridge;
    wine = self.wineUsingFull;
  };

  waybar = super.waybar.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [
      super.libnotify.dev
      super.upower.dev
    ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ super.cmake ];
  });

  weylus = super.weylus.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "H-M-H";
      repo = "Weylus";
      rev = "d30b8b3e56820b72a858e227654823722f0d5d8f";
      hash = "sha256-TpCUtrk2oqjB0CEWy96fSz1w1HjZrwEVqwVqlWqkQD8=";
    };

    patches = [
      ../patches/weylus.patch
    ];

    cargoDeps = super.rustPlatform.importCargoLock {
      lockFile = src + /Cargo.lock;
      outputHashes = {
        "autopilot-0.4.0" = "sha256-1DRuhAAXaIADUmXlDVr8UNbI/Ab2PYdrx9Qh0j9rTX8=";
      };
    };
  });
}
