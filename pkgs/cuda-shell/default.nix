{ gcc9Stdenv, lib, buildFHSUserEnv, cudaPackages, linuxPackages, curl, libGL
, xorg, }:
let
  libPath = lib.makeLibraryPath
    ([ linuxPackages.nvidia_x11 gcc9Stdenv.cc.cc gcc9Stdenv.cc.libc ]
      ++ (with cudaPackages; [ cudatoolkit cudnn ]));
in buildFHSUserEnv rec {
  name = "cuda-shell";
  targetPkgs = p:
    (with p; [
      autoconf
      binutils
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
    ]) ++ (with cudaPackages; [ cudatoolkit cudnn ]);

  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash";
  profile = ''
    export CUDA_PATH=${cudaPackages.cudatoolkit}
    export CUDA_LD_LIBRARY_PATH=${libPath}
    export LDFLAGS="-L${linuxPackages.nvidia_x11}/lib -L${cudaPackages.cudatoolkit}/lib -L${cudaPackages.cudnn}/lib"
    export CFLAGS="-I${cudaPackages.cudatoolkit}/include -I${cudaPackages.cudnn}/include"
  '';
}
