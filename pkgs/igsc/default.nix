{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  systemd,
}:
let
  metee = stdenv.mkDerivation rec {
    pname = "metee";
    version = "6.0.0";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = version;
      hash = "sha256-XGHYwYVYPOASmKb7s8JeBbcA9SOIGXqL66I/ieAr+p8=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "0.9.5";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "6abae21408bc36561baaade9fca9ae4a5173d2f0";
    hash = "sha256-ecjcDYirbJC2s48+SOwFuJAJQ6eaabTrmgTjgb+dXrA=";
  };

  buildInputs = [
    metee
    systemd.dev
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
}
