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
      rev = "46931fda41bcafebc04f096f5fa74e554b97f3d9";
      hash = "sha256-PJAbvOeQz6AUfz3llBIDWeUo/0bfQPyhM0GqhEDxQIU=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
  };
in
stdenv.mkDerivation {
  pname = "igsc";
  version = "0.9.4";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    rev = "fbaa86af735dc255a6d54c6fb1e247e3195872b8";
    hash = "sha256-UiyisaQM/wbgFhzhn1kNG993+8yHPLtbeqGkuu8kNRE=";
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
