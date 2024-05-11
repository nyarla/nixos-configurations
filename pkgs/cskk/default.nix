{
  fetchFromGitHub,
  rustPlatform,
  cargo-c,
  rust-bindgen,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "git";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = pname;
    rev = "432295efcff4c236e82beb635b2e8e862fb40b95";
    hash = "sha256-mhQZeCa4shxO8/kRqAwR60pwvfeQ9Ue+r25BtTAI1Hw=";
  };

  cargoHash = "sha256-9LV1N6SZi0mPBNi5A4CHbxWxQVlMLsAfGhXkJ3FQkgk=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [
    cargo-c
    rust-bindgen
  ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
