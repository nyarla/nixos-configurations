{
  sources,
  lib,

  rustPlatform,

  makeWrapper,
  pkg-config,
  wayland-protocols,
  wayland-scanner,

  dbus,
  fontconfig,
  freetype,
  gtk3,
  libGL,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxinerama,
  libxkbcommon,
  mesa,
  vulkan-loader,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "YoluPainter";
  inherit (sources.${finalAttrs.pname}) version;
  src = sources.${finalAttrs.pname};

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  cargoBuildFeatures = [
    "eframe/x11"
    "eframe/wayland"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    wayland-protocols
    wayland-scanner
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    gtk3
    libGL
    libglvnd
    libx11
    libxcb
    libxcursor
    libxi
    libxinerama
    libxkbcommon
    mesa
    vulkan-loader
    wayland
  ];

  checkPhase = "true";

  postInstall = ''
    test ! -e $out/bin/xtask || rm $out/bin/xtask

    for bin in $(ls $out/bin); do
      wrapProgram $out/bin/$bin \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath finalAttrs.buildInputs}"
    done
  '';
})
