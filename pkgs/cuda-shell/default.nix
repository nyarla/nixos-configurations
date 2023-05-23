{ gcc9Stdenv, lib, buildFHSUserEnv, cudatoolkit_latest, linuxPackages, curl
, libGL, xorg, }:
let
  libPath = lib.makeLibraryPath [
    linuxPackages.nvidia_x11
    gcc9Stdenv.cc.cc
    gcc9Stdenv.cc.libc
  ];
in buildFHSUserEnv rec {
  name = "cuda-shell";
  targetPkgs = p:
    (with p; [
      autoconf
      binutils
      cudatoolkit_latest
      curl
      freeglut
      gcc9Stdenv.cc
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
      unzip
      util-linux
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXmu
      xorg.libXrandr
      xorg.libXv
      zlib
    ]) ++ [ cudatoolkit_latest ];

  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash";
  profile = ''
    export CUDA_PATH=${cudatoolkit_latest}
    export CUDA_LD_LIBRARY_PATH=${libPath}
    export EXTRA_LDFLAGS="-L/lib -L${linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
