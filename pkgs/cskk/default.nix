{
  sources,

  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cskk";
  inherit (sources.cskk) version;
  src = sources.cskk;

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall \
      --prefix=$out \
      --libdir=$out/lib \
      --includedir=$out/include \
      --pkgconfigdir=$out/lib/pkgconfig \
      --datarootdir=$out/share

    cd $out/lib
    for f in $(ls cskk); do
      ln -sf $out/lib/cskk/$f $f
    done
  '';
})
