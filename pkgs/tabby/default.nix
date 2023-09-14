{ gcc9Stdenv, fetchFromGitHub, rustPlatform, nvidia_x11, cudaPackages_11_2
, protobuf, cmake, pkg-config, openssl, openblas, llvmPackages_10 }:
let
  CTranslate2 = gcc9Stdenv.mkDerivation rec {
    pname = "Ctranslate2";
    version = "497833";
    src = fetchFromGitHub {
      owner = "OpenNMT";
      repo = "CTranslate2";
      rev = "4978339f304035b1f86bcf59cd19aa7e79831744";
      sha256 = "sha256-aSYE8+vhCsgZf1gBqJFRK8cn91AxrRutJc3LzHQQHVc=";
      fetchSubmodules = true;
    };

    cmakeFlags = [
      "-DWITH_CUDA=ON"
      "-DWITH_CUDNN=ON"
      "-DWITH_MKL=OFF"
      "-DWITH_OPENBLAS=ON"
    ];
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ openblas nvidia_x11 llvmPackages_10.openmp ]
      ++ (with cudaPackages_11_2; [ cudatoolkit cudnn ]);
  };

  llamacpp = gcc9Stdenv.mkDerivation rec {
    pname = "llamacpp";
    version = "06fc40";
    src = fetchFromGitHub {
      owner = "TabbyML";
      repo = "llama.cpp";
      rev = "06fc4020de0b92ee13407fdabca7870f53c75de5";
      sha256 = "sha256-HzluwwhoFsspta0RXEf0g3FWjSKK0P2lSN/9kA+wbFk=";
    };

    cmakeFlags = [
      "-DLLAMA_BLAS=ON"
      "-DLLAMA_CUBLAS=ON"
      "-DLLAMA_CUDA_F16=ON"
      "-DLLAMA_LTO=ON"
      "-DLLAMA_NATIVE=ON"
    ];
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ openblas ];

    installPhase = ''
      mkdir -p $out/
      cd ..
      cp -R . $out/
    '';
  };
in rustPlatform.buildRustPackage rec {
  pname = "tabby";
  version = "12a37e2";

  src = fetchFromGitHub {
    owner = "TabbyML";
    repo = "tabby";
    rev = "3d00cc5e87bb5b6b36a936638700c81962fc89eb";
    sha256 = "sha256-CowmEdKoZAIp1f9yD/yUxKhPE6ap6qXtn0OUUf8bFCw=";
  };
  cargoSha256 = "sha256-rNN69r/YUTBoplkkjrI5zdZZa5U7d/YiV1ibAIopP4w=";

  CTRANSLATE2_ROOT = "${CTranslate2}";
  buildFeatures = [ "link_shared" ];

  nativeBuildInputs = [ cmake pkg-config protobuf ];

  buildInputs = [
    CTranslate2
    llamacpp
    llvmPackages_10.openmp
    nvidia_x11
    openblas.dev
    openssl.dev
  ] ++ (with cudaPackages_11_2; [ cudatoolkit cudnn ]);

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
