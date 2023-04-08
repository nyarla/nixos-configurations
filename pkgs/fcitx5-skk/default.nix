# copied from https://github.com/NixOS/nixpkgs/issues/167872 and modified
{ lib, stdenv, fetchFromGitHub, fcitx5, fcitx5-qt, cmake, extra-cmake-modules
, gettext, gcc, pkg-config, qt5, libskk, skk-dicts, enableQt ? true }:

stdenv.mkDerivation rec {
  pname = "fcitx5-skk";
  version = "5.0.15";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-y5GciWJMEFQM8SsqYANXe/SdVq6GEqsfF1yrKKhw0KA=";
  };

  cmakeFlags = [
    "-DENABLE_QT=${toString enableQt}"
    "-DSKK_DEFAULT_PATH=${skk-dicts}/share/SKK-JISYO.combined"
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules gettext gcc pkg-config ];

  buildInputs = [ libskk fcitx5 fcitx5-qt ] ++ lib.optional enableQt qt5.qtbase;

  dontWrapQtApps = true;

  meta = with lib; {
    description =
      "fcitx5-skk is an input method engine for Fcitx5, which uses libskk as its backend.";
    homepage = "https://github.com/fcitx/fcitx5-skk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
