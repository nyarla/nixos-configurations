{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "clipboard-sync";
  version = "git";

  src = fetchFromGitHub {
    owner = "dnut";
    repo = pname;
    rev = "e2520a2796f798382c6fc6e9dca5a279282237e7";
    sha256 = "sha256-/LV2j0QSsxohth1I9ZkXHIlzQcmD6wV3Kq1XGJZkh4E=";
  };

  buildInputs = (
    with xorg;
    [
      libxcb
      libXrender
      libXfixes
    ]
  );
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-pA8G9G9mPfBtM116iyoS2bkmD16g3D6vrF6SPIwr8Ig=";
}
