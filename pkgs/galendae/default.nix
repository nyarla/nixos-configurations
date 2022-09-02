{ stdenv, fetchFromGitHub, gtk3, pkg-config, wrapGAppsHook }:
stdenv.mkDerivation rec {
  pname = "galendae";
  version = "git";
  src = fetchFromGitHub {
    owner = "chris-marsh";
    repo = "galendae";
    rev = "7cf032bba678c0782412d3407fabdc750f966f3f";
    sha256 = "07mnmj1fh1s763vs97hpmzsiyx52fss52m8d6jf8frgxasap6sb1";
  };

  buildInputs = [ gtk3.dev pkg-config ];

  patchPhase = ''
    sed 's|CFLAGS += -DVERSION|#CFLAGS += -DVERSION|' makefile
  '';

  buildPhase = ''
    make -f makefile release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp galendae $out/bin/
    chmod +x $out/bin/*
  '';
}
