{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  gradle,
  jetbrains,

  fontconfig,
  libGL,
  libX11,
  libz,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flare";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "DimensionDev";
    repo = "Flare";
    tag = finalAttrs.version;
    hash = "sha256-3UpZkvyIkkc/NFGkFcHNJeQbaJyKNuvHSnm7qS5MoJ8=";
  };

  prePatch = ''
    cat build.gradle.kts ${./init-deps.gradle.kts} > build.gradle.kts.new
    mv build.gradle.kts.new build.gradle.kts
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.libc

    fontconfig
    libGL
    libX11
    libz
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dos.family=linux"
    "-Dos.arch=amd64"
    "-Dorg.gradle.java.home=${jetbrains.jdk}"
  ];

  gradleBuildTask = "createReleaseDistributable";
  gradleUpdateTask = "downloadDeps";

  preGradleUpdate = ''
    gradle --parallel :desktopApp:checkRuntime
    gradle --parallel :desktopApp:installJnaNative_5.18.1 
    gradle --parallel :desktopApp:installSqliteJni_2.6.2
    gradle --parallel :shared:kspCommonMainKotlinMetadata
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r desktopApp/build/compose/binaries/main-release/app/Flare $out/app

    cat <<... > $out/bin/Flare 
    #!${stdenv.shell}

    export LD_LIBRARY_PATH=${lib.makeLibraryPath finalAttrs.buildInputs}

    exec -a Flare $out/app/bin/Flare "''${@:-}"
    ...

    chmod +x $out/bin/Flare

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode
    binaryNativeCode
  ];
})
