{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.3.0";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = version;
    hash = "sha256-F4sqyqD8Qdc/mhPpINCFjzuWiBOKSat5YIT1WnoEHck=";
  };

  useFetchVendor = true;
  cargoHash = "sha256-YvjDvLwnLKxCf2vqj1JhYVnwKZt6vxihT25FYa4qFzc=";

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
}
