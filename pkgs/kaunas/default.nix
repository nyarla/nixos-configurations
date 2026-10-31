{ sources, stdenvNoCC }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "Kaunas";
  inherit (sources.Kaunas) version;
  src = sources.Kaunas;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/${finalAttrs.pname}
    cp -r openbox-3 $out/share/themes/${finalAttrs.pname}/

    runHook postInstall
  '';
})
