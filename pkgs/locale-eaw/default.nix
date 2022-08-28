{ stdenv, fetchFromGitHub, python3 }:
stdenv.mkDerivation rec {
  pname = "locale-eaw";
  version = "2022-08-28";
  src = fetchFromGitHub {
    owner = "hamano";
    repo = "locale-eaw";
    rev = "e66bf2c9be26cd54c0bb978d63a23738e9352b4c";
    sha256 = "1fazcm2l2np2d6qh43zc2147x5xamvlqfw8f4nqdgz6g9zy8avf5";
  };

  nativeBuildInputs = [ python3 ];

  buildPhase = ''
    make UTF-8-EAW-FULLWIDTH
  '';

  installPhase = ''
    mkdir -p $out/
    cp UTF-8-EAW-FULLWIDTH $out/UTF-8
  '';
}
