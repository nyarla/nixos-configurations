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
  version = "v1.2.0";
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-cskk";
    rev = "223c99a5dde7362f51059a15849edceb4a030d0a";
    hash = "sha256-NSYtVX7XE9WkI8g1s+pC4/7QHEbQ3GO87ZZA9oMo090=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ] ++ lib.optional enableQt wrapQtAppsHook;

  buildInputs =
    [
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
