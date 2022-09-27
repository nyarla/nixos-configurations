{ stdenv, fetchFromGitHub, cmake, pkg-config, boost, cudatoolkit, netcdf }:
stdenv.mkDerivation rec {
  pname = "currennt";
  version = "git";
  src = fetchFromGitHub {
    owner = "nii-yamagishilab";
    repo = "project-CURRENNT-public";
    rev = "7ca0103e13d7e868a451690679e16fa6a59d1146";
    sha256 = "0kizzi2qlm8xknayi8kb5sfr9mqqiigqsg5swxcrqlzvs2zxzppx";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost.dev cudatoolkit netcdf ];

  postUnpack = ''
    sourceRoot=source/CURRENNT_codes
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp currennt $out/bin/
    chmod +x $out/bin/currennt
  '';
}
