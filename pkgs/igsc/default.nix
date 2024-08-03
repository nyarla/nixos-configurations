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
    version = "4.2.0";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = "50d018b207b13a63d384b3a4e1a4a00d5a13d9dd";
      hash = "sha256-8uOixeH8AFS1bIRfdO9mv3BDAY8Ef+/JoMWQDrLqbzo=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "d22dc41badc3b0ef2b690a903745a0dee357c070";
    hash = "sha256-JUXLML3s8Y/FJaGYTDmVFveO2tZtvVIY3rFGPv0RwU4=";
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
