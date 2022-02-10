{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config, boost, cudatoolkit
, jsoncpp, mesa, ocl-icd, opencl-headers, opencl-info, openssl }:
stdenv.mkDerivation rec {
  pname = "nsfminer";
  version = "1.3.14";
  src = fetchFromGitHub {
    owner = "no-fee-ethereum-mining";
    repo = "nsfminer";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0c4ffb25pkpjzkjgjz35kkabyqiv80q1zchfjyx4kcr335yd0gyr";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];
  buildInputs = [
    boost
    cudatoolkit
    jsoncpp
    mesa
    ocl-icd
    opencl-headers
    opencl-info
    openssl.dev
  ];

  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    #"-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    #"-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  postPatch = ''
    sed -i 's!ss << ifs.rdbuf();!ss << ifs.rdbuf(); string line = ss.str();!' nsfminer/main.cpp
    sed -i 's!args, ss.str()!args, line!' nsfminer/main.cpp
  '';

  preConfigure = ''
    sed -i 's/-O2/-Ofast -mavx2 -funroll-loops/' CMakeLists.txt
    sed -i 's/_lib_static//' libpool/CMakeLists.txt
  '';

  postInstall = ''
    wrapProgram $out/bin/nsfminer --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';
}
