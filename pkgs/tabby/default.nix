{
  gcc9Stdenv,
  fetchFromGitHub,
  rustPlatform,
  nvidia_x11,
  cudaPackages_11_2,
  protobuf,
  cmake,
  pkg-config,
  openssl,
  openblas,
  llvmPackages_10,
}:
let
  CTranslate2 = gcc9Stdenv.mkDerivation rec {
    pname = "Ctranslate2";
    version = "497833";
    src = fetchFromGitHub {
      owner = "OpenNMT";
      repo = "CTranslate2";
      rev = "8bcbeb6ff95b6906c9d5f7740fa9491431fa3e30";
      hash = "sha256-OtUwJ+hvlGQw129PQetGjZKOF4Wvqs+5gSHFk/skShY=";
      fetchSubmodules = true;
    };

    cmakeFlags = [
      "-DWITH_CUDA=ON"
      "-DWITH_CUDNN=ON"
      "-DWITH_MKL=OFF"
      "-DWITH_OPENBLAS=ON"
    ];
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs =
      [
        openblas
        nvidia_x11
        llvmPackages_10.openmp
      ]
      ++ (with cudaPackages_11_2; [
        cudatoolkit
        cudnn
      ]);
  };

  llamacpp = gcc9Stdenv.mkDerivation rec {
    pname = "llamacpp";
    version = "f858db";
    src = fetchFromGitHub {
      owner = "TabbyML";
      repo = "llama.cpp";
      rev = "f858db8db3a98968ad3764c409e43e44c443079b";
      hash = "sha256-y6ns1vwqDfEb/S1wMit0wY+hLOW543ClRU9QTkyd0uc=";
    };

    cmakeFlags = [
      "-DLLAMA_BLAS=ON"
      "-DLLAMA_CUBLAS=ON"
      "-DLLAMA_CUDA_F16=ON"
      "-DLLAMA_LTO=ON"
      "-DLLAMA_NATIVE=ON"
    ];
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [ openblas ];

    installPhase = ''
      mkdir -p $out/
      cd ..
      cp -R . $out/
    '';
  };
in
rustPlatform.buildRustPackage rec {
  pname = "tabby";
  version = "76c2cd2";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "76c2cd25a4c1229c47dcf118a25f07d167dc47e7";
    hash = "sha256-5C6N7CZQCIhP/8XrdhrhOALKBzYHyV45RHMOwEIJlO0=";
  };

  cargoHash = "sha256-fdX3A4Xg3tNQie8K/WwsnK0i1SID6Fd+a1YAQ1mxEKc=";

  CTRANSLATE2_ROOT = "${CTranslate2}";
  buildFeatures = [ "link_shared" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      CTranslate2
      llamacpp
      llvmPackages_10.openmp
      nvidia_x11
      openblas.dev
      openssl.dev
    ]
    ++ (with cudaPackages_11_2; [
      cudatoolkit
      cudnn
    ]);

  postPatch = ''
    sed -i 's|let dst|// let dst|' crates/llama-cpp-bindings/build.rs
    sed -i 's|, dst.display()||' crates/llama-cpp-bindings/build.rs 
    sed -i "s|native={}|native=${llamacpp}|" crates/llama-cpp-bindings/build.rs

    sed -i 's|let dst = link_static();|// let dst = link_static();|' crates/ctranslate2-bindings/build.rs
    sed -i 's|lib.flag_if_supported(&format!("-I{}", dst.join("include").display()))||' crates/ctranslate2-bindings/build.rs
  '';

  postConfigure = ''
    mkdir -p crates/llama-cpp-bindings/llama.cpp
    cp -R ${llamacpp}/* crates/llama-cpp-bindings/llama.cpp/
    chmod -R +w crates/llama-cpp-bindings/llama.cpp
  '';
}
