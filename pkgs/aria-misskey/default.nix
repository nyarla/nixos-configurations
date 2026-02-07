{
  stdenv,
  lib,
  runCommand,
  fetchFromGitHub,
  fetchurl,

  flutter338,
  rustPlatform,
  cargo,
  yq,

  libepoxy,
  libva,
  libvdpau,
  mdk-sdk,
}:
let
  pname = "aria";
  version = "v1.4.2";

  source = fetchFromGitHub {
    owner = "poppingmoon";
    repo = pname;
    rev = version;
    hash = "sha256-rf1vl8Bbu2srb8mE+Ia788K99Coihz3SA5uPbyK6MYo=";
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

    isar_community_flutter_libs =
      { version, src, ... }:
      let
        libisar = fetchurl {
          url = "https://github.com/isar-community/isar-community/releases/download/3.2.1/libisar_linux_x64.so";
          sha256 = "0kbabshlzxza8iq398x5hq0afrl761kz1k2fz79v7rjvw4fwdihg";
        };
      in
      stdenv.mkDerivation rec {
        pname = "isar_community_flutter_libs";
        inherit version src;
        inherit (src) passthru;

        installPhase = ''
          runHook preInstall

          cp -r . $out 

          substituteInPlace $out/packages/isar_community_flutter_libs/linux/CMakeLists.txt \
            --replace-fail 'include("../cargokit/cmake/cargokit.cmake")' "" \
            --replace-fail 'apply_cargokit(''${PROJECT_NAME} packages/isar_core_ffi isar "")' "" \
            --replace-fail "\''${\''${PROJECT_NAME}_cargokit_lib}" "${libisar}"

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
    fvp = "sha256-PCXmoZhrfavvX2W1hDtECh6KncHLam+JYAYMG7wjFZs=";
    highlighting = "sha256-r2rMvgHt312F64dy4aIRr+eD9Q0sJ7eGe6DGP57t50M=";
    image_compression = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    isar_community_flutter_libs = "sha256-Ff8Y0K0djQP1AgnttZdNbnWCJl6svWLd1lt14/tsF/o=";
    isar_community_generator = "sha256-t27LINKquVH8M9wc+NGwNm8dw1fkAAhvI+LBwLW2FVo=";
    # material_off_icons = "sha256-jMO1abOm1YgFAAbFaTFgTjrmQGW6d7Z1J4o2wTynto4=";
    mfm_parser = "sha256-fwhKTPbuuEtimWhtUxsDNqHb0TDBqjdsNQN0RIq7Rq0=";
    misskey_dart = "sha256-SLiSlQu08oGMrgKFbyjpWSh48BuvNxmps7BWqeM0Nrs=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    tinycolor2 = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    twemoji_v2 = "sha256-liX5FrM5lgJUXo6HfgIgiY4MnnvCNRYIY7nOTkrSt6k=";
    unifiedpush_android = "sha256-SXidD6t7xRA5bXma7UPbw331d9zjdU1Bp/H9I8VLLs4=";
    webcrypto = "sha256-AELwdBRSBcjHNlprlFXoP5rKOG6J5PG3cwTa+gZps6U=";
  };

  targetFlutterPlatform = "linux";

  cargoRoot = "rust";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + /rust/Cargo.lock;
    outputHashes = {
      "aiscript-0.1.0" = "sha256-JARrHUJY2dPx0gNWyWI3wHSZW3upe3CkDYgVBrr5CRo=";
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
    export LD_LIBRARY_PATH=$out/app/aria/lib:${
      lib.makeLibraryPath [
        libva
        libvdpau
      ]
    }
    exec $out/app/aria/aria
    EOF

    chmod +x $out/bin/aria
  '';
}
