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
