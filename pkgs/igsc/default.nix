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
    version = "4.1.0";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = "921a33401c738382bbc839a46e657e5881f94269";
      hash = "sha256-nARxsxG0Ey3rKFxxXkdfdVm1lMlFQCpOIWR9gDC9V8o=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "0.8.16";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "ed8de901694cd9e27ac66725cdac13f86d61781f";
    hash = "sha256-mavEMdDB8PQzhgsj0THfExgStxzy7HrSDprpdvchCbY=";
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
