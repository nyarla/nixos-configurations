{ gcc9Stdenv, lib, buildFHSUserEnv, cudaPackages_12_1, linuxPackages, curl
, libGL, libibumad, ucx, xorg, qt6, rdma-core, libtiff, gst_all_1 }:
let
  libPath = lib.makeLibraryPath [
    linuxPackages.nvidia_x11
    gcc9Stdenv.cc.cc
    gcc9Stdenv.cc.libc
  ];

  libtiff5 = libtiff.overrideAttrs (old: rec {
    postFixup = old.postFixup + ''
      cd $out/lib
      ln -sf libtiff.so libtiff.so.5
    '';
  });

  cuda-fix = cudaPackages_12_1.cudatoolkit.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [
      curl
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer.out
      libibumad
      libtiff5.out
      qt6.qtwayland
      rdma-core
      ucx
      xorg.libxkbfile
      xorg.libxshmfence
    ];

    dontWrapQtApps = true;
  });
in buildFHSUserEnv rec {
  name = "cuda-shell";
  targetPkgs = p:
    with p; [
      autoconf
      binutils
      cuda-fix
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
    ];

  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash";
  profile = ''
    export CUDA_PATH=${cuda-fix}
    export CUDA_LD_LIBRARY_PATH=${libPath}
    export EXTRA_LDFLAGS="-L/lib -L${linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
