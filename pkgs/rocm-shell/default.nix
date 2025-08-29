{
  buildFHSEnv,
}:
buildFHSEnv {
  name = "rocm-shell";
  targetPkgs =
    p:
    with p;
    [
      autoconf
      binutils
      cmake
      curl
      freeglut
      git
      gitRepo
      glib
      gnumake
      gnupg
      gperf
      gperftools
      libGL
      libGLU
      m4
      ncurses5
      procps
      unzip
      util-linux
      zlib
      zstd

      # for comfyUI
      sentencepiece
    ]
    ++ (with rocmPackages.gfx12; [
      llvm.libcxx
    ]);

  runScript = "bash";
  profile = ''
    export ROCM_PATH=/opt/rocm
  '';
}
