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
    version = "6.1.0";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = version;
      hash = "sha256-ybTi4pFZAkoO6FAyUOLK+ZbTQb7uwu/sqhYxo06SE9A=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "5a69634ac5e38d28c8354967ab0f1c7034586ccd";
    hash = "sha256-OpEsJrObkjoDmVy9mxEf/+CzcNZXWIDhDRfQbPyiyPM=";
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
