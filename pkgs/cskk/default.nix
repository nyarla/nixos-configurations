{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.2.0";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = "v3.2.0";
    hash = "sha256-lhLNtSmD5XiG0U6TLWgN+YA/f7UJ/RyHoe5vq5OopuI=";
  };

  useFetchVendor = true;
  cargoHash = "sha256-XWPeqQ3dC73Hp+TTPdLJtvF0hQ+uI82xfY7DxAXO1gA=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
