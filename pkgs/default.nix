self: super:
let require = path: args: super.callPackage (import path) args;
in {
  # musics
  currennt = require ./currennt { cudatoolkit = self.cudatoolkit_latest; };

  # nvidia
  cudatoolkit_latest = super.cudaPackages_11_6.cudatoolkit;
  nvidia-x11_latest = super.linuxPackages_lqx.nvidiaPackages.stable;

  # mining
  ethminer = super.ethminer.override {
    inherit (super.llvmPackages_13) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  };

  nsfminer = (require ./nsfminer {
    inherit (super.llvmPackages_13) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  xmrig = (super.xmrig.override {
    inherit (super.llvmPackages_13) stdenv;
  }).overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "MoneroOcean";
      repo = "xmrig";
      rev = "v6.16.4-mo1";
      sha256 = "sha256-OnKz/Sl/b0wpZ1tqeEXhNxNNmQJXBhv5YNnKu9aOVZA=";
    };
  });
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_13) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  };
}
