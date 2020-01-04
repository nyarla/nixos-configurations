{ stdenv, makeWrapper, makeDesktopItem, fetchFromGitHub, gnused,
  pkgconfig, gnome3, xorg,
  alsaLib, curl, freetype, libGL, libjack2
}:
let
  desktopItem = makeDesktopItem {
    name = "Helio";
    exec = "Helio";
    icon = "Helio";
    desktopName = "Helio Workstation";
    genericName = "Helio Workstation";
    categories  = "Application;Music;";
  };
in
stdenv.mkDerivation rec {
  version = "716a4a14f03665f88634b4d0c0d180071143e0be";
  name    = "helio-workstation-${version}";
  src     = fetchFromGitHub {
    owner = "helio-fm";
    repo  = "helio-workstation";
    rev   = "${version}";
    fetchSubmodules = true;
    sha256 = "1hssyzg5h5g56zad65llzca7dq8q11hpg468q7qgllvcf91lcmpn";
  };

  nativeBuildInputs = [
    pkgconfig makeWrapper gnused
  ];

  buildInputs = [
    alsaLib curl freetype libGL libjack2
  ] ++ (with xorg; [
    libX11 libXext libXinerama libXrandr
    libXcursor libXcomposite
  ]) ++ (with gnome3; [
    zenity
  ]);

  preBuild = "cd Projects/LinuxMakefile";
  buildFlags = [ "CONFIG=Release64" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps
    install -m +x build/Helio $out/bin
    wrapProgram $out/bin/Helio --prefix PATH ":" ${gnome3.zenity}/bin

    cp -R ${desktopItem}/ $out/
    cp ../../Resources/logo-v2.png $out/share/icons/hicolor/512x512/apps/Helio.png
  '';
}
