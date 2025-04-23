{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.1.5";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = "af413a14bcafc811264bdedbe3bd5f943d2e7f5e";
    hash = "sha256-sYtYwwBPP1nTbIYLQGdMEYO8lybkaTaLjwqHO7b0Puo=";
  };

  useFetchVendor = true;
  cargoHash = "sha256-eKH7DJV5a0IhBAsXsmhzc/EF0S2KxyVwzd47HlgGj3s=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
