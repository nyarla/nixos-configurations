{ fetchFromGitHub, rustPlatform, cargo-c, rust-bindgen, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.1.0";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = pname;
    rev = "d783896ddc8510e564d542fc56c6486834424be6";
    hash = "sha256-xOCR5wfVC8OeCieC7YGlWoxRUB5MFbuk40irLS0ngBc=";
  };

  cargoHash = "sha256-lKLbs2Q3Vt4nIvlMBqjiPn7exO6F2y/D8AvpTPtusbo=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [ cargo-c rust-bindgen ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
