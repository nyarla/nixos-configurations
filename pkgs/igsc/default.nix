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
      rev = "bc8ffd2236b644ee1d62ae6afc6a6026ba784a90";
      hash = "sha256-MYGHoRiNUcuCviu2mpFkErfYxm2JLB1qov6NPNtnRZs=";
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
