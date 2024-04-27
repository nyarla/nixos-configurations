{
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  nvidia_x11,
  cudaPackages_12_0,
}:
stdenv.mkDerivation rec {
  pname = "turbopilot";
  version = "eaeb52f";

  src = fetchFromGitHub {
    owner = "ravenscroftj";
    repo = "turbopilot";
    rev = "eaeb52fcb03de77e4f350a8837428413d9437c5d";
    hash = "sha256-0D4GekNW0CEu1rgWTdG1606jzgEVaVK3lcmOEPmXUTw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    sed -i 's|includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@|\@CMAKE_INSTALL_FULL_LIBDIR@|' \
      extern/argparse/packaging/pkgconfig.pc.in

    sed -i 's|''${prefix}/''${CMAKE_INSTALL_INCLUDEDIR}|\@CMAKE_INSTALL_FULL_LIBDIR@|' \
      extern/spdlog/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DGGML_CLBLAST=ON"
    "-DGGML_CUBLAS=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      boost.dev
      nvidia_x11
    ]
    ++ (with cudaPackages_12_0; [
      cudatoolkit
      cudnn
    ]);

  preInstall = ''
    mkdir -p $out/bin
    cp bin/turbopilot $out/bin/
    chmod +x $out/bin/*
  '';
}
