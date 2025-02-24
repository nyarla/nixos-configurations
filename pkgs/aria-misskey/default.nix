{
  stdenv,
  lib,
  runCommand,
  fetchFromGitHub,

  flutter329,
  rustPlatform,
  cargo,
  yq,
}:
let
  source = fetchFromGitHub {
    owner = "poppingmoon";
    repo = "aria";
    rev = "7a6ec27c9c2f1a5bef0cc4ebff67833c76908478";
    hash = "sha256-akIAJmeb4jiYhRCmf3XDrS8h8R3wdfOcpMJ5a9+XB3U=";
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
flutter329.buildFlutterApplication rec {
  pname = "aria";
  version = "v1.0.0-beta.9";
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
    "flutter_highlighting" = "sha256-YtCAFbFrSwjW4WRqMXWty60Q4GFVX0OTIBqn2GsLRj4=";
    "flutter_html" = "sha256-/BrcXZ6im/Sb3UVbdlfjYV3R3lOzKdmoAWY4ikgoVRg=;";
    "highlighting" = "sha256-IedjKNGFBSbU4vu5x8GI28WL4uJ8B/kvw6iGkX2+uGg=";
    "image_compression" = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    "material_off_icons" = "sha256-jMO1abOm1YgFAAbFaTFgTjrmQGW6d7Z1J4o2wTynto4=";
    "mfm_parser" = "sha256-GJUTuX3cPYe3Weo5VzYVXJuvc0EmrLmxCGgStYfH1lk=";
    "misskey_dart" = "sha256-SXHpV8ZeKAojgongzIyf28Yj2aK7s1j1cQoJ9lmojp8=";
    "receive_sharing_intent" = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    "tinycolor2" = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    "twemoji_v2" = "sha256-Gi9PIMpw4NWkk357X+iZPUhzIKMDg5WdzTPHvJDBzSg=";
    "webcrypto" = "sha256-KXPJk/Da9LiM0q8URqGz5zAioHpJALlqbUNeZLNrNMY=";
  };

  targetFlutterPlatform = "linux";

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
