{ fetchFromGitHub, rustPlatform, cargo-c, rust-bindgen, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "cskk";
  version = "v3.1.0";
  src = fetchFromGitHub {
    owner = "naokiri";
    repo = pname;
    rev = "432295efcff4c236e82beb635b2e8e862fb40b95";
    hash = "sha256-mhQZeCa4shxO8/kRqAwR60pwvfeQ9Ue+r25BtTAI1Hw=";

  };

  cargoHash = "sha256-oHtwjLvfMVMWiaHlZoaiLR8YXRg0g9I0YlbsKozasv4=";

  buildInputs = [ libxkbcommon.dev ];
  nativeBuildInputs = [ cargo-c rust-bindgen ];

  postInstall = ''
    cargo cinstall --prefix=$out
  '';
}
