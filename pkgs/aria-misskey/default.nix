{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  writeText,
  makeWrapper,

  cargo,
  flutter,
  rustPlatform,
  yq,

  gst_all_1,
  libepoxy,
  libunwind,
  libva,
  libvdpau,
  mdk-sdk,
  orc,
}:
let
  pname = "aria";
  version = "v1.5.5";

  src = fetchFromGitHub {
    owner = "poppingmoon";
    repo = pname;
    rev = version;
    hash = "sha256-eX9fU+dqZpY7LD87yeBr/TUOLpEvWg+CvK3Nu5BR2YM=";
  };

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

    isar_community =
      { version, src, ... }:
      let
        libisar = fetchurl {
          url = "https://github.com/poppingmoon/isar-community/releases/download/v3.3.2-2026.06.02/libisar_x86_64-unknown-linux-gnu.so";
          sha256 = "19si6iwdy9r1nq83x3kf0gyssxd5idjr19clma22c7ajx0q7ps5g";
        };

        build-dart = writeText "build.dart" ''
          import 'dart:io';

          import 'package:code_assets/code_assets.dart';
          import 'package:hooks/hooks.dart';
          import 'package:isar_community/src/hook_helpers/config_mapping.dart';
          import 'package:isar_community/src/hook_helpers/hashes.dart';
          import 'package:path/path.dart' as path;

          void main(List<String> args) async {
            await build(args, (input, output) async {
              final CodeConfig(:linkMode) = input.config.code;
              output.assets.code.add(
                CodeAsset(
                  package: input.packageName,
                  name: 'src/native/bindings.dart',
                  linkMode: linkMode,
                  file: path.toUri('${libisar}'),
                ),
              );
            });
          }
        '';
      in
      stdenv.mkDerivation {
        pname = "isar_community";
        inherit version src;
        inherit (src) passthru;

        installPhase = ''
          runHook preInstall

          cp -r . $out
          chmod -R +w $out

          cp ${build-dart} $out/packages/isar_community/hook/build.dart

          runHook postInstall
        '';
      };
  };
in
flutter.buildFlutterApplication rec {
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
    animated_image = "sha256-AMsx73y+rxftbr2HMbyEG2PMSGBxQsTkGej5q9Vmyww=";
    flutter_apns_only = "sha256-5KlICoKqekSE4LCzd1MP+o8Ezq0xLZmzeAQZExXBalM=";
    flutter_cache_manager = "sha256-4sMjeSMOsEicIVLdY+evnl0HbvMcm4PLG8JL4e4yxBE=";
    flutter_highlighting = "sha256-5t4hXvqkhwohTuFoeVycwb9HKZDDug+HjkGPeItVrTk=";
    flutter_inappwebview = "sha256-Kj77JgQpGIYEyQffjvC6xEGp0zXvKxGVdqZ5mG1x9/o=";
    flutter_inappwebview_macos = "sha256-Kj77JgQpGIYEyQffjvC6xEGp0zXvKxGVdqZ5mG1x9/o=";
    fvp = "sha256-5lX6kYQytRjfdV13bhQ0N58E5p431zVoo7m6N4MQITg=";
    highlighting = "sha256-r2rMvgHt312F64dy4aIRr+eD9Q0sJ7eGe6DGP57t50M=";
    image_compression = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    isar_community = "sha256-6M+xZ5WfN+mblzBfI1cvQFXpmZdzBayYWlMD3QrMAJc=";
    isar_community_generator = "sha256-6M+xZ5WfN+mblzBfI1cvQFXpmZdzBayYWlMD3QrMAJc=";
    jni = "sha256-aR8QENpt1T+3SuodhGyR7kzuAYd/KbmXB8SlREp1z3U=";
    mfm_parser = "sha256-LW0kpCGbLAnCfYzC4ivydcnYV44Hla/uwdYvhEiwl5c=";
    misskey_dart = "sha256-ImGSLFDz09HMhbsHAuFyKqmAZIT703yVZ8UbYMlqLzw=";
    mobile_scanner = "sha256-jCbexwsGxY3qCaeqQSSNWOkMSupoR5K7DW4KAxtfZwo=";
    native_toolchain_cmake = "sha256-2oGoQZ1nz1q3LYVSkjTGIbHg0Akzw7hGcD8+th0y6zI=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    tinycolor2 = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    twemoji_v2 = "sha256-XQ/Y3rAK1apXQ/+pw6xi+5JZ1GB26Np9Ziq3arUuZcg=";
    unifiedpush_android = "sha256-SXidD6t7xRA5bXma7UPbw331d9zjdU1Bp/H9I8VLLs4=";
    webcrypto = "sha256-Nv/4w15rFjNmxYM/Cbpy4IT/4aeK78GUHx3onZQZOSA=";
    webfont_list = "sha256-mp+cO/U6X9gXdFT5aXAM2mmH1RjmWaJlPLTGdG/YGHs=";
  };

  targetFlutterPlatform = "linux";

  cargoRoot = "rust";
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + /rust/Cargo.lock;
    outputHashes = {
      "aiscript-0.1.0" = "sha256-GHmw8XisIu3sFy7acAOUdTbzh1nIFUR/0g0CnyBJFLA=";
    };
  };

  dontCargoBuild = true;
  cargoBuildFlags = "--lib";
  cargoBuildType = "release";

  postUnpack = ''
    cp ${./build.dart} source/hook/build.dart
  '';

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
    libunwind.dev
    orc.dev
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad.dev
    gst-plugins-base.dev
    gst-plugins-good.dev
    gst-plugins-ugly.dev
    gstreamer.dev
  ]);

  nativeBuildInputs = [
    cargo
    rustPlatform.bindgenHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoSetupHook
    makeWrapper
  ];

  libPath =
    lib.makeLibraryPath buildInputs
    + (
      ":"
      + lib.makeSearchPathOutput "lib" "lib64" (
        [
          libva
          libvdpau
        ]
        ++ (with gst_all_1; [
          gst-plugins-bad
          gst-plugins-base
          gst-plugins-good
          gst-plugins-ugly
          gstreamer
        ])
      )
    );

  postInstall = ''
    mkdir -p $out/bin
    ln -sf $out/app/aria/aria $out/bin/aria

    wrapProgram $out/bin/aria \
      --prefix LD_LIBRARY_PATH : "${libPath}:$out/app/aria/lib"
  '';
}
