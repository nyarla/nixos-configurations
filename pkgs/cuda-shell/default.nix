{ stdenv, lib, buildFHSUserEnv, cudatoolkit, linuxPackages, libGL }:
let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    stdenv.cc.libc
    linuxPackages.nvidia_x11
  ];
in buildFHSUserEnv rec {
  name = "cuda-shell";
  targetPkgs = p:
    with p; [
      autoconf
      binutils
      cudatoolkit
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
      stdenv.cc
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
    export CUDA_PATH=${cudatoolkit}
    export LD_LIBRARY_PATH=${libPath}
    export EXTRA_LDFLAGS="-L/lib -L${linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
