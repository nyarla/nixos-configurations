{
  stdenv,
  lib,
  runCommand,
  fetchFromGitHub,

  flutter338,
  rustPlatform,
  cargo,
  yq,

  libepoxy,
  mdk-sdk,
}:
let
  pname = "aria";
  version = "v1.4.0-beta.2";

  source = fetchFromGitHub {
    owner = "poppingmoon";
    repo = pname;
    rev = version;
    hash = "sha256-tdLrxWf+0EKfLLB7ll0p0oXUI3PvtV9Eo3+Atl+tlJw=";
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
flutter338.buildFlutterApplication rec {
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
    fvp = "sha256-PgxJVEr0oOtuP3xf0ybw3wyIpzz8zKGt3ASl1psp+1Y=";
    highlighting = "sha256-r2rMvgHt312F64dy4aIRr+eD9Q0sJ7eGe6DGP57t50M=";
    image_compression = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    material_off_icons = "sha256-jMO1abOm1YgFAAbFaTFgTjrmQGW6d7Z1J4o2wTynto4=";
    mfm_parser = "sha256-fwhKTPbuuEtimWhtUxsDNqHb0TDBqjdsNQN0RIq7Rq0=";
    misskey_dart = "sha256-npX0jI4x7E9u1X5R4qRxRyAMReIhmRG2vqtnB4b/fP8=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    tinycolor2 = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    twemoji_v2 = "sha256-liX5FrM5lgJUXo6HfgIgiY4MnnvCNRYIY7nOTkrSt6k=";
    unifiedpush_android = "sha256-NDnQYBAjQC+fI3a9sdqmr/4Er+nGtG3caCZM6C1cXAk=";
    webcrypto = "sha256-AELwdBRSBcjHNlprlFXoP5rKOG6J5PG3cwTa+gZps6U=";
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
