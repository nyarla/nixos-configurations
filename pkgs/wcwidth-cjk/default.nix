{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  name = "wcwidth-cjk-${src.rev}";
  src = fetchFromGitHub {
    owner = "fumiyas";
    repo = "wcwidth-cjk";
    rev = "a1b1e2c346a563f6538e46e1d29c265bdd5b1c9a";
    sha256 = "182z37h2k2r27xf2916j58myfsjqfkpfgykg9nw05kanppql16hj";
  };

  #patches = [ ./waltarix.patch ];

  buildInputs = [ autoreconfHook ];

  preAutoConf = ''
    mkdir m4
  '';

  meta = with lib; {
    description = "Run command with CJK-friendly wcwidth(3) to fix ambiguous width chars";
    homepage = "https://github.com/fumiyas/wcwidth-cjk";
    license = lib.licenses.bsd2;
    maintainers = [ "nyarla <nyarla@kalaclista.com>" ];
  };
}
