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
  useQt6 ? true,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-cskk";
  version = "da7e2ce";
  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-cskk";
    rev = "da7e2ce7d8f1319368adae3d9e96513058c40018";
    hash = "sha256-qJ3UQphoHOSa4wYowR6wQp+RakovoQVzuii4DAWUWuY=";
  };

  patches = [
    ./fix-build-on-qt5.patch
  ];

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
    (lib.cmakeBool "ENABLE_QT" enableQt)
    (lib.cmakeBool "USE_QT6" useQt6)
    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)
    "-DSKK_DICT_DEFAULT_PATH=${skkDictionaries.l}/share/SKK-JISYO.L"
  ];
}
