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
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-cskk";
  version = "v1.2.0";
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-cskk";
    rev = version;
    hash = "sha256-rDaFsBXd3he40W27B6641qEfPYBpuw7Rc8JhvsZiPFg=";
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
    "-DSKK_DICT_DEFAULT_PATH=${skkDictionaries.l}/share/SKK-JISYO.L"
  ];
}
