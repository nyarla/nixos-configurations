{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.1.3";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = version;
    hash = "sha256-z3f84HhiWSvKTW26aT23KV2HBRIFqQtrJ6qc6hTaiKU=";
  };

  cargoHash = "sha256-udN/EXjd/MrOgVszTv8rQLWh0UcH8R3XE+kTBp6WEi0=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
