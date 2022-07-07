self: super:
let require = path: super.callPackage (import path);
in {
  # additional packages
  JUCE = require ./JUCE { };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  dexed = require ./dexed { };
  fcitx5-skk = require ./fcitx5-skk { inherit (super.libsForQt5) fcitx5-qt; };
  skk-dicts-xl = require ./skk-dicts-xl { };
  terminfo-mlterm-256color = require ./terminfo-mlterm-256color { };

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

  quodlibet =
    super.quodlibet.overrideAttrs (_: rec { doInstallCheck = false; });

  thunderbird-bin-unwrapped =
    super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  xmrig = super.xmrig.override { inherit (super.llvmPackages_14) stdenv; };
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };
}
