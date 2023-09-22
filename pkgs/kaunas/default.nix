{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  pname = "Kaunas";
  version = "git";
  src = fetchFromGitHub {
    owner = "Dovias";
    repo = pname;
    rev = "98a7b76c2c42c94a83db0d0c1205bf6f7a171084";
    hash = "sha256-+fonEBF+LKrLdySQeM6cjrj5UgjXLLCwWosoGOxXPBU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/${pname}
    cp -R ${src}/openbox-3 $out/share/themes/${pname}/openbox-3

    runHook postInstall
  '';
}
