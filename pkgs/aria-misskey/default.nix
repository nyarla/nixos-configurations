{
  stdenv,
  lib,
  runCommand,
  fetchFromGitHub,

  flutter335,
  rustPlatform,
  cargo,
  yq,

  libepoxy,
  mdk-sdk,
}:
let
  pname = "aria";
  version = "v1.4.0-beta.1";

  source = fetchFromGitHub {
    owner = "poppingmoon";
    repo = pname;
    rev = version;
    hash = "sha256-42yTf6kZMLZwL1aQ0/CYeaYjEtK8rmt4x9vtNhXMCe8=";
    fetchSubmodules = true;
  };

  src = runCommand "aria-src" { } ''
    mkdir -p $out
    cp -r '${source}'/* "$out"

    chmod -R +w $out
    cd $out
    patch -p1 -i ${./rust_lib_aria.patch}
  '';

  customSourceBuilders = {
    fvp =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "fvp";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          sed -i 's|.*libc++.so.1.*|${mdk-sdk}/lib/libc++.so.1|' ./linux/CMakeLists.txt
          substituteInPlace ./linux/CMakeLists.txt \
            --replace-fail "fvp_setup_deps()" "include(${mdk-sdk}/lib/cmake/FindMDK.cmake)"
        '';

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };
in
flutter335.buildFlutterApplication rec {
  inherit pname version src;

  pubspecLock =
    let
      lockfile = runCommand "build-aria-pubspec.json" { nativeBuildInputs = [ yq ]; } ''
        yq '.' ${src}/pubspec.lock > $out
      '';
    in
    lib.importJSON "${lockfile}";

  inherit customSourceBuilders;

  gitHashes = {
    flutter_apns_only = "sha256-5KlICoKqekSE4LCzd1MP+o8Ezq0xLZmzeAQZExXBalM=";
    flutter_cache_manager = "sha256-4sMjeSMOsEicIVLdY+evnl0HbvMcm4PLG8JL4e4yxBE=";
    flutter_highlighting = "sha256-5t4hXvqkhwohTuFoeVycwb9HKZDDug+HjkGPeItVrTk=";
    highlighting = "sha256-r2rMvgHt312F64dy4aIRr+eD9Q0sJ7eGe6DGP57t50M=";
    image_compression = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    material_off_icons = "sha256-jMO1abOm1YgFAAbFaTFgTjrmQGW6d7Z1J4o2wTynto4=";
    mfm_parser = "sha256-ntDalOugbrtRiKIpbE7JY2+QlmnmTqGwCIvm3l2EiAY=";
    misskey_dart = "sha256-X7TsVFyktcVTVQj6Ls8qPxjhm/Ufuq9EbYnU8VD1JiM=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    tinycolor2 = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    twemoji_v2 = "sha256-5Z0tUfrRRN9/vXJRNXt8IZaKMFYFXTnvAvy3lo5M3wQ=";
    unifiedpush_android = "sha256-n7G0r2TIIpp1E0bC/FGl95fTAxtOf1K8fjCXEK5fndo=";
    webcrypto = "sha256-Bjm3ouci5W636hiZthMEvxoImqf3L4ZGzkeAIiZJhHE=";
  };

  targetFlutterPlatform = "linux";

  cargoRoot = "rust";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + /rust/Cargo.lock;
    outputHashes = {
      "aiscript-0.1.0" = "sha256-GJccX0YHBpvLL0YElQIaJ6ooIIvKRIA426OlJeHrrN4=";
    };
  };

  dontCargoBuild = true;
  cargoBuildFlags = "--lib";
  cargoBuildType = "release";

  preBuild = ''
    preBuild=()
    cd rust
    cargoBuildHook
    mv ./target/*/release/librust_lib_aria.* ./target/release/
    cd ..
  '';

  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  buildInputs = [
    libepoxy.dev
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    rm $out/bin/aria
    cat <<EOF >$out/bin/aria
    #!${stdenv.shell}
    export LD_LIBRARY_PATH=$out/app/aria/lib
    exec $out/app/aria/aria
    EOF

    chmod +x $out/bin/aria
  '';
}
