{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  systemd,
}:
let
  metee = stdenv.mkDerivation {
    pname = "metee";
    version = "4.2.1";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = "6f3ada2480f8071beb1200555976c159fc63507b";
      hash = "sha256-2sy1qwlCdYE6dOPHpdkeX8ueZr+q72qhm9RZh+kHSuA=";
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
    rev = "fcfa86452b50f62e30393ba5e554d413c7b6dca9";
    hash = "sha256-r6lJi21xiMnQDufrO+LHADhSaJXnD/rvc6+xWVjW2GE=";
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
