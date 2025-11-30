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
    rev = "44794f29c89de994b0179aebabd2f5776c90d236";
    hash = "sha256-Ejr2wDs3tr36YN2mWSd9ZKp5e6gH/whcuhauN/2Y15I=";
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
