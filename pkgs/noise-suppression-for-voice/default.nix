{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  juce,
}:
stdenv.mkDerivation rec {
  pname = "noise-suppression-for-voice";
  version = "2024-05-18";
  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "9c4e5c28d8950e2cef837d8a0abd36c2fd9b5c2d";
    hash = "sha256-HtWDwKZ4UFLE7k93ONcubrMmvFYvDKgZwFSkqgXiCXY=";
    fetchSubmodules = true;
  };

  inherit (juce) buildInputs;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
}
