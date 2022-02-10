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
  nvidia-x11_latest = super.linuxPackages.nvidiaPackages.stable;

  # mining
  ethminer = (super.ethminer.override {
    stdenv = super.llvmPackages_13.stdenv;
    cudatoolkit = self.cudatoolkit_11_5;
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

  nsfminer = (require ./pkgs/nsfminer {
    stdenv = super.llvmPackages_13.stdenv;
    cudatoolkit = self.cudatoolkit_11_5;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  xmrig = super.xmrig.override { stdenv = super.llvmPackages_13.stdenv; };
  xmrig-cuda = require ./pkgs/xmrig-cuda {
    stdenv = super.llvmPackages_13.stdenv;
    cudatoolkit = self.cudatoolkit_11_5;
  };
}
