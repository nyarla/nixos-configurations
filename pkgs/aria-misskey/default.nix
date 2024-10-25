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
    rev = "80362a9ef7006781bac6e009c5d887567cf86376";
    hash = "sha256-w0o1qU04VtsFos+17Zu+Y5uzmrAUwHXi2v5LCLOBSSY=";
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
  version = "v1.0.0-beta.2";
  inherit src;

  pubspecLock =
    let
      lockfile = runCommand "build-aria-pubspec.json" { nativeBuildInputs = [ yq ]; } ''
        yq '.' ${src}/pubspec.lock > $out
      '';
    in
    lib.importJSON "${lockfile}";

  gitHashes = {
    "flutter_apns_only" = "sha256-5KlICoKqekSE4LCzd1MP+o8Ezq0xLZmzeAQZExXBalM=";
    "flutter_launcher_icons" = "sha256-/oYrlXShHgB/5u694Fe3PY7kCksaqgX59S3YaQf71Ik=";
    "highlighting" = "sha256-IedjKNGFBSbU4vu5x8GI28WL4uJ8B/kvw6iGkX2+uGg=";
    "mfm_parser" = "sha256-zi/K0R9mGy4Y/eLyZYEP0eEQSftprDsjyA/++t1AJdY=";
    "misskey_dart" = "sha256-+wHM70FXIhkduirnfkUz3DU7ZRjEp1m2wY6byMYq6gE=";
    "tinycolor2" = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    "twemoji_v2" = "sha256-Gi9PIMpw4NWkk357X+iZPUhzIKMDg5WdzTPHvJDBzSg=";
    "webcrypto" = "sha256-9xZqJdgm9Ngv0fJwzIZJ0mHyPYMY8JsEh6nOm2RbYR0=";
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
