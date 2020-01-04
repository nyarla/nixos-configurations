{ multiStdenv, fetchurl, fetchzip, cmake, makeWrapper, file, xorg, qt5, wineWowPackages }:
let
  vst2sdk = fetchzip {
    url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
    sha256 = "1x4qfviwcssk4fswhqks745jicblpy352kd69p7cqmgfcxhckq79";
  };
in multiStdenv.mkDerivation rec {
  version = "git";
  name = "airwave-${version}";
  src = fetchurl {
    url = "https://github.com/psycha0s/airwave/archive/master.tar.gz";
    sha256 = "1br95fcjkf0jimlyl7w9lqnzqrkynpcyzymb5licmn8p5cmgmpr5";
  };

  buildInputs = [
    cmake makeWrapper
  ];

  nativeBuildInputs = [
    file xorg.libX11 qt5.qtbase wineWowPackages.staging
  ];
   
  postPatch = ''
    substituteInPlace src/common/storage.cpp --replace '"/bin"' '"/libexec"'
    substituteInPlace src/host/CMakeLists.txt --replace '-m32' \
      '-m32 -L${wineWowPackages.staging}/lib -L${wineWowPackages.staging}/lib/wine -L${multiStdenv.cc.libc.out}/lib/32'
  '';

  dontPatchELF = true;

  hardeningDisable = [ "format" ];

  cmakeFlags = "-DVSTSDK_PATH=${vst2sdk}";

  postInstall = ''
    mv $out/bin $out/libexec
    mkdir $out/bin
    mv $out/libexec/airwave-manager $out/bin
    wrapProgram $out/libexec/airwave-host-32.exe --set WINELOADER ${wineWowPackages.staging}/bin/wine
    wrapProgram $out/libexec/airwave-host-64.exe --set WINELOADER ${wineWowPackages.staging}/bin/wine64
  '';

}
