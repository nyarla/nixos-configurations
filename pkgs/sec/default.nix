{
  lib,
  fetchFromGitHub,
  makeWrapper,

  stdenvNoCC,

  bws,
  jq,
  libsecret,
}:
stdenvNoCC.mkDerivation (finalAttr: {
  pname = "sec";
  version = "2026-01-10";
  src = fetchFromGitHub {
    owner = "nyarla";
    repo = finalAttr.pname;
    rev = "c462f77e21b4480ada952e5e6bc7f29fe28a2728";
    hash = "sha256-/CFLmfGzESWj3GurwX6HStBFM8mq+sPDh4JjPA1xAgE=";
  };

  buildInputs = [
    makeWrapper

    bws
    jq
    libsecret
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${finalAttr.src}/bin/sec $out/bin/sec
    chmod +x $out/bin/sec

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/sec \
      --prefix PATH : ${
        lib.makeBinPath [
          bws
          jq
          libsecret
        ]
      }
  '';
})
