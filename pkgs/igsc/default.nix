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
    version = "6.2.4";
    src = fetchFromGitHub {
      owner = "intel";
      repo = "metee";
      rev = version;
      hash = "sha256-TMHc/0N1DUx+aKOCrfBRoQgKj968FIq+FcusyLG0oPI=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "7b83853dce5b8e0be4db11076807c9f402139506";
    hash = "sha256-GdeGGrnkxJQlg+vVQan5rJW/rxlStD4TAmWxfloX0+k=";
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
