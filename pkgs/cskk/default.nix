{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage {
  pname = "cskk";
  version = "v3.1.2";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = "cskk";
    rev = "9d96fd17161dcac85a202d27da789415f3182c4f";
    hash = "sha256-drBuYasp8FIHMOFWFVd31GRNvE4a6A3V+0KS2NnJzoI=";
  };

  cargoHash = "sha256-A0LtCiSlJUJWwg+nPT7mO+GtySakVEB6fPyMvFLs+EA=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
