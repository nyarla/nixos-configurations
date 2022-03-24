self: super:
let require = path: args: super.callPackage (import path) args;
in {
  # musics
  currennt = require ./currennt { cudatoolkit = self.cudatoolkit_latest; };

  # nvidia
  cudatoolkit_latest = super.cudatoolkit.override {
    version = "11.6.0";
    url =
      "https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run";
    sha256 = "10wcv42ljp7hz1k0wzgwb4hi8834rfipzdc01428c1wpcdnxm0qp";
    gcc = super.gcc10;
  };
  nvidia-x11_latest = super.linuxPackages_lqx.nvidiaPackages.stable;

  # mining
  ethminer = (super.ethminer.override {
    inherit (super.llvmPackages_13) stdenv;
    cudatoolkit = self.cudatoolkit_latest;
  }).overrideAttrs (old: rec {
    version = "1.9.2";
    src = super.fetchFromGitHub {
      owner = "danieleftodi";
      repo = "ethminer";
      rev = "59e063c57d44b3de5393b81f92d89b76d86107a3";
      sha256 = "1ra1jlc8s3r12qzqkbqzf8646cbj219mqdms04wdzaya2af444h6";
      fetchSubmodules = true;
    };
    postPatch = ''
      sed -i 's|jsoncpp_static|jsoncpp|' libpoolprotocols/CMakeLists.txt
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

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
