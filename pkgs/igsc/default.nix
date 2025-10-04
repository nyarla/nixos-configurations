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
    version = "6.0.2";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = "93784f62070b2bc4e84b51e23c9add61f7600444";
      hash = "sha256-eQpw0VdO+JGtgW4FGduoxY0Gji4hFPSONcEzDRcgWGU=";
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
