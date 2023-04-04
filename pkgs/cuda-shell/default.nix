{ gcc9Stdenv, lib, buildFHSUserEnv, cudaPackages_12_0, linuxPackages, libGL }:
let
  libPath = lib.makeLibraryPath [
    linuxPackages.nvidia_x11
    gcc9Stdenv.cc.cc
    gcc9Stdenv.cc.libc
  ];
in buildFHSUserEnv rec {
  name = "cuda-shell";
  targetPkgs = p:
    with p; [
      autoconf
      binutils
      cudaPackages_12_0.cudatoolkit
      curl
      freeglut
      git
      gitRepo
      gnumake
      gnupg
      gperf
      libGL
      libGLU
      m4
      ncurses5
      procps
      gcc9Stdenv.cc
      unzip
      util-linux
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXmu
      xorg.libXrandr
      xorg.libXv
      zlib
    ];

  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash";
  profile = ''
    export CUDA_PATH=${cudaPackages_12_0.cudatoolkit}
    export CUDA_LD_LIBRARY_PATH=${libPath}
    export EXTRA_LDFLAGS="-L/lib -L${linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
