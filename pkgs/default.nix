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
  juce-framework = require ./juce-framework { };
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
      version = "2022-08-13";
      src = super.fetchFromGitHub {
        owner = "labwc";
        repo = "labwc";
        rev = "19dea7450b127e7ef4ef8e2c4bb7f7ad94712353";
        sha256 = "1gdxzvb2i0p832mdby9f9y2jwiga1r2mq5ngb2cqlarvgd89x36p";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.libxkbcommon ];
    configureFlags = (super.lib.remove "--with-gui=xlib,fb" old.configureFlags)
      ++ [ "--with-gui=xlib,fb,wayland" ];
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
    version = "2022-08-13";
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "c20468cfa292e99357fd504fc5b5884f6078ca96";
      sha256 = "sha256-O7o/25v07Da4Wt4lBq3CZ5kOObyx3Knp4zFnlvvwHmU=";
    };

    patches = [ ../patches/wlroots-workaround.patch ];
  });

  xmrig = super.xmrig.override { inherit (super.llvmPackages_14) stdenv; };
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };
}
