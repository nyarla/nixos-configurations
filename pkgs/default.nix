self: super:
let require = path: super.callPackage (import path);
in {
  # additional packages
  arc-openbox = require ./arc-openbox { };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  dexed = require ./dexed { };
  fcitx5-skk = require ./fcitx5-skk { inherit (super.libsForQt5) fcitx5-qt; };
  gyazo-diy = require ./gyazo-diy { };
  hack-nerdfonts = require ./hack-nerdfonts { };
  hackgen = require ./hackgen { };
  juce-framework = require ./juce-framework { };
  locale-eaw = require ./locale-eaw { };
  mlterm-wrapped = require ./mlterm-wrapped { inherit (self) mlterm; };
  restic-run = require ./restic-run { };
  sfwbar = require ./sfwbar { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sysmontask = require ./sysmontask { };
  terminfo-mlterm-256color = require ./terminfo-mlterm-256color { };
  wayout = require ./wayout { };
  wcwidth-cjk = require ./wcwidth-cjk { };
  wine-run = require ./wine-run { };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # modified packages
  calibre = super.calibre.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.python3Packages.pycrypto ];
  });

  ethminer = super.ethminer.override {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };

  firefox-bin-unwrapped =
    super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = (super.labwc.override { inherit (self) wlroots; }).overrideAttrs
    (old: rec {
      version = "2022-08-28";
      src = super.fetchFromGitHub {
        owner = "labwc";
        repo = "labwc";
        rev = "8a7048fd789bf0a1fcea48ab4a5b3aac61e48d61";
        sha256 = "120lblb6hg8f54idxh0dcn6n4cfm64l0psj71vhkq9xlpkvjih4x";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs
      ++ (with super; [ libxkbcommon SDL2.dev gdk-pixbuf.dev ]);
    configureFlags = (super.lib.remove "--with-gui=xlib,fb" old.configureFlags)
      ++ [ "--with-gui=xlib,fb,wayland,sdl2" ];

    NIX_LDFLAGS = old.NIX_LDFLAGS + ''
      -lm
    '';
  });

  nsfminer = (require ./nsfminer {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  thunderbird-bin-unwrapped =
    super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  wlroots = super.wlroots.overrideAttrs (old: rec {
    version = "2022-08-28";
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "fa7d2cb8d60ed48c44c707106c03682056ddfaca";
      sha256 = "1058kk0nas944nw3305dqh43ck1h2ndh1xbyzj9kp8221ly85jbx";
    };

    patches = [ ../patches/wlroots-workaround.patch ];
  });

  xmrig = super.xmrig.override { inherit (super.llvmPackages_14) stdenv; };
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };
}
