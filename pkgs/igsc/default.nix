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
    version = "6.1.2";
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
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "9122018f1b72d63c49bd750e29c1cd8b2b2ddd3f";
    hash = "sha256-eBN05r2o6MUTJvIrkwY2uic7afj6YMHvt/apHyyGgug=";
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
