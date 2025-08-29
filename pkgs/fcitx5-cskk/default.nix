{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  gettext,
  fcitx5,
  fcitx5-qt,
  qtbase,
  wrapQtAppsHook,
  cskk,
  skkDictionaries,
  enableQt ? false,
  useQt6 ? false,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-cskk";
  version = "6d4407c";
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-cskk";
    rev = "6d4407c64df46423c378afeefa71bda3282a7cec";
    hash = "sha256-UfEmRenWiX2xbIirkDRbix1YQrDz1/sVg6yut8ZRJ0k=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ]
  ++ lib.optional enableQt wrapQtAppsHook;

  buildInputs = [
    fcitx5
    cskk
  ]
  ++ lib.optionals enableQt [
    fcitx5-qt
    qtbase
  ];

  cmakeFlags = [
    "-DENABLE_QT=${toString enableQt}"
    "-DUSE_QT6=${toString useQt6}"
    "-DSKK_DICT_DEFAULT_PATH=${skkDictionaries.l}/share/SKK-JISYO.L"
  ];
}
