self: super:
let require = path: args: super.callPackage (import path) args;
in {
  # terminal
  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.libxkbcommon ];
    configureFlags = (super.lib.remove "--with-gui=xlib,fb" old.configureFlags)
      ++ [ "--with-gui=xlib,fb,wayland" ];
  });

  # input method
  fcitx5-skk = require ./fcitx5-skk { inherit (super.libsForQt5) fcitx5-qt; };

  # musics
  currennt = require ./currennt { cudatoolkit = self.cudatoolkit_latest; };

  # nvidia
  cudatoolkit_latest = super.cudaPackages_11_6.cudatoolkit;

  # mining
  ethminer = super.ethminer.override {
    inherit (super.llvmPackages_14) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  };

  nsfminer = (require ./nsfminer {
    inherit (super.llvmPackages_14) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  xmrig = super.xmrig.override { inherit (super.llvmPackages_14) stdenv; };
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_14) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  };
}
