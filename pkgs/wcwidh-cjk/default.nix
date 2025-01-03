{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "wcwidth-cjk";
  version = "a1b1e2c+locale-eaw-console";
  src = fetchFromGitHub {
    owner = "fumiyas";
    repo = "wcwidth-cjk";
    rev = "a1b1e2c346a563f6538e46e1d29c265bdd5b1c9a";
    hash = "sha256-EppA8b1WzQK4TW/65+50WGrnKyrShCRcPyKLKeAZX6A=";
  };

  patches = [
    ./locale-eaw-console.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];
}
