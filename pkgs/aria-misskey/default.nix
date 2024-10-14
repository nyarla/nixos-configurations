{
  stdenv,
  lib,
  runCommand,
  fetchFromGitHub,

  flutter324,
  rustPlatform,
  cargo,
  yq,
}:
let
  source = fetchFromGitHub {
    owner = "poppingmoon";
    repo = "aria";
    rev = "30124fd8a9a74a21c92a1bc7eeebb1b39c42cd75";
    hash = "sha256-54Mw/Ckh11El6+lUf/N64F0DskSM7b3gkiEZ60WF3Iw=";
    fetchSubmodules = true;
  };

  src = runCommand "aria-src" { } ''
    mkdir -p $out
    cp -r '${source}'/* "$out"

    chmod -R +w $out
    cd $out
    patch -p1 -i ${./rust_lib_aria.patch}
  '';
in
flutter324.buildFlutterApplication rec {
  pname = "aria";
  version = "2024-09-13";
  inherit src;

  pubspecLock =
    let
      lockfile = runCommand "build-aria-pubspec.json" { nativeBuildInputs = [ yq ]; } ''
        yq '.' ${src}/pubspec.lock > $out
      '';
    in
    lib.importJSON "${lockfile}";

  gitHashes = {
    "flutter_launcher_icons" = "sha256-/oYrlXShHgB/5u694Fe3PY7kCksaqgX59S3YaQf71Ik=";
    "mfm_parser" = "sha256-zi/K0R9mGy4Y/eLyZYEP0eEQSftprDsjyA/++t1AJdY=";
    "misskey_dart" = "sha256-WdQg21VpP5LbvQj8qMo9CBi2Wh3FREe8Wwlg54Xtyl0=";
    "tinycolor2" = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    "twemoji_v2" = "sha256-Gi9PIMpw4NWkk357X+iZPUhzIKMDg5WdzTPHvJDBzSg=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + /rust/Cargo.lock;
    outputHashes = {
      "aiscript-0.1.0" = "sha256-4OGaYbMlQn/Ejh8Ff2uhJbHTkf85CwoGOPdr9m5/B0U=";
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
    export LD_LIBRARY_PATH=$out/app/lib
    exec $out/app/aria
    EOF

    chmod +x $out/bin/aria
  '';
}
