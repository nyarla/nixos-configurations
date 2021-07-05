{ stdenv, lib, fetchFromGitHub, autoreconfHook }:
stdenv.mkDerivation rec {
  name = "wcwidth-cjk-${src.rev}";
  src = fetchFromGitHub {
    owner = "fumiyas";
    repo = "wcwidth-cjk";
    rev = "b15d9d13e1a4c3e7a281cae53135315348eaf9e0";
    sha256 = "1127cdwpl2shv1lsg7l1q0cyf9x6qyvl25c3m0gfpvha305i45bi";
  };

  meta = with lib; {
    description =
      "Run command with CJK-friendly wcwidth(3) to fix ambiguous width chars";
    homepage = "https://github.com/fumiyas/wcwidth-cjk";
    license = lib.licenses.bsd2;
    maintainers = [ "nyarla <nyarla@thotep.net>" ];
  };

  patches = [ ./waltarix.patch ];

  buildInputs = [ autoreconfHook ];
  preAutoConf = ''
    mkdir m4
  '';

}
