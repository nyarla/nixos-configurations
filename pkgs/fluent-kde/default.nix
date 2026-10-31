{
  sources,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "Fluent-kde";
  version = "git";
  src = sources.Fluent-kde;

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
