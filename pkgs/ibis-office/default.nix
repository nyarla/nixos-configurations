{
  sources,
  lib,

  rustPlatform,
  makeWrapper,
  pkg-config,

  atk,
  fontconfig,
  glib,
  gtk3,
  libxcb,
  libxkbcommon,
  vulkan-headers,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ibis-office";
  inherit (sources.${finalAttrs.pname}) version;
  src = sources.${finalAttrs.pname};

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  buildInputs = [
    atk
    fontconfig
    glib
    gtk3
    libxcb
    libxkbcommon
    vulkan-headers
    vulkan-loader
    wayland
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  checkPhase = "true";

  preFixup = (finalAttrs.preFix or "") + ''
    for file in $(ls $out/bin); do
      wrapProgram $out/bin/$file \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath finalAttrs.buildInputs}
    done
  '';
})
