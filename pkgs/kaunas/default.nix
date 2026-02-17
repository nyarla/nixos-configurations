{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "Kaunas";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "Dovias";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-tWSU0XnjrAbGPcbxu+BK8Djv62yLLwqhK+sVrE52xpk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/${finalAttrs.pname}
    cp -r openbox-3 $out/share/themes/${finalAttrs.pname}/

    runHook postInstall
  '';
})
