{
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Fluent-kde";
  version = "git";
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Fluent-kde";
    rev = "9d6b7d4733707c38f72e8a614528f1df591419f3";
    hash = "sha256-eRAM4f2scGLSDNljI3qjyn5XF7zjrsp8ArIGswNyimY=";
  };

  installPhase = ''
    mkdir -p $out/share/Kvantum
    mkdir -p $out/share/aurorae/themes
    mkdir -p $out/share/color-schemes
    mkdir -p $out/share/plasma

    cp -r Kvantum/Fluent* $out/share/Kvantum/
    cp -r aurorae/Fluent* $out/share/aurorae/themes/
    cp -r color-schemes/* $out/share/color-schemes/
    cp -r plasma/* $out/share/plasma/
  '';
}
