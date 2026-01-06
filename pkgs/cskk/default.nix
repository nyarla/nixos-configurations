{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.2.1";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = "v3.2.1";
    hash = "sha256-olQ0ru5JPx3F0nL+EVR5rmR7nAfceUPSzaATRACJUJU=";

  };

  useFetchVendor = true;
  cargoHash = "sha256-YvjDvLwnLKxCf2vqj1JhYVnwKZt6vxihT25FYa4qFzc=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
