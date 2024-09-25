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
    rev = "a023375083b6d87238c5a0998bf82b27abb7a153";
    hash = "sha256-fketb9ZIb+5wM31yeht19Vd4FInU8wskM2Z67Ffd6dg=";
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
    "mfm_parser" = "sha256-mOvzB80Um8sk6jAhyvsm2uraYjrcwJ/dq0W6lZHDxWI=";
    "misskey_dart" = "sha256-SC/J+knB3JjYJkQGLWazxqZqXzzVYESh981/dTo6f9E=";
    "tinycolor2" = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    "twemoji_v2" = "sha256-Gi9PIMpw4NWkk357X+iZPUhzIKMDg5WdzTPHvJDBzSg=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + /rust/Cargo.lock;
    outputHashes = {
      "aiscript-0.1.0" = "sha256-+I2WlUbaykjSmY9qKhR9SMeJ9cRMtSXO0Zw0Yyzjr1E=";
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
    export LD_LIBRARY_PATH=\$(pwd)/lib
    exec \$(pwd)/aria
    EOF

    chmod +x $out/bin/aria
  '';
}
