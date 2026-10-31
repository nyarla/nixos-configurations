{
  sources,

  pname,
  datetime,

  appId ? "ai.storyteller.${pname}",
  features ? [ ],
  extraBuildInputs ? [ ],
  patches ? [ ],

  cargoHashes ? { },

  rustPlatform,
  lib,

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

  makeWrapper,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname;
  inherit (sources.${pname}) version;
  src = sources.${pname};

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = cargoHashes;
  };

  cargoBuildFeatures = [
    "eframe/x11"
    "eframe/wayland"
  ]
  ++ features;

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
  ]
  ++ extraBuildInputs;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    wayland-protocols
    wayland-scanner
  ];

  inherit patches;

  checkPhase = "true";

  postInstall = ''
    install -Dm644 ${finalAttrs.src}/packaging/linux/${appId}.desktop \
      $out/share/applications/${appId}.desktop

    install -Dm644 ${finalAttrs.src}/packaging/linux/${appId}.mime.xml \
      $out/share/mime/package/${appId}.xml

    install -Dm644 ${finalAttrs.src}/packaging/linux/${appId}.metainfo.xml.in \
      $out/share/metainfo/${appId}.metainfo.xml 

    substituteInPlace $out/share/metainfo/${appId}.metainfo.xml \
      --replace-fail '@VERSION@' "${sources.${pname}.version}" \
      --replace-fail '@DATE@' "${datetime}"

    test ! -e $out/bin/xtask || rm $out/bin/xtask

    wrapProgram $out/bin/${pname} \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath finalAttrs.buildInputs}"

    wrapProgram $out/bin/${pname}-cli \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

})
