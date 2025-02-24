{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.1.4";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = "f1ee557c2834e065cfb6e74f8c4d8535292772db";
    hash = "sha256-EsMxEbDDYkJmwP2FsSUBVm7VdRe2efV+iKKx5ycqxeI=";
  };

  cargoHash = "sha256-C25AAyrRfxflsAsuh175bCZ2khEBjKxN1ejWWTm2FzU=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
