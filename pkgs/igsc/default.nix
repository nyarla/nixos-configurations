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
    version = "5.0.0";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = version;
      hash = "sha256-LcAfsJsDSoHpzI5j0SJ9AyR5nFn0d2RrML02K0SOAEc=";
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
    rev = "ba6f2afbd96385fcb6b2a6e3c8e459727c8401fa";
    hash = "sha256-vCOwCW6rDi1oQUPEGoZz7mqGr3rcRLDfqrbt9/LvYoA=";
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
