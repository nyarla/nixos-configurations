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
    rev = "d720a1852d77099797f9e5cb26e21c0e4bc77f5c";
    hash = "sha256-q+fpOxB09c7Ao+80EaUR3RMgWY6nHoRx7+vkX2JB4wo=";
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
  version = "v1.0.0-beta.6";
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
    export LD_LIBRARY_PATH=$out/app/aria/lib
    exec $out/app/aria/aria
    EOF

    chmod +x $out/bin/aria
  '';
}
