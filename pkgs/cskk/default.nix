{ fetchFromGitHub, rustPlatform, cargo-c, rust-bindgen, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = pname;
    rev = version;
    hash = "sha256-xOCR5wfVC8OeCieC7YGlWoxRUB5MFbuk40irLS0ngBc=";
  };

  cargoHash = "sha256-l3Xv03P4aVnWZh4+acOdD2031eKfdsVqy3HyS+28n3A=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [ cargo-c rust-bindgen ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
