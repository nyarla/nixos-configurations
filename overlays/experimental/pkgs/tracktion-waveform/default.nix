{ stdenv, fetchurl, atk, patchelf
, alsaLib, freetype, curlFull, libjack2, libglvnd, libX11, libXext, 
}:
stdenv.mkDerivation rec {
  version = "8.2.7";
  name    = "tracktion-waveform-${version}";

  src = fetchurl {
    url     = "https://s3-us-west-2.amazonaws.com/tracktion-marketplace-public/archive/waveform/827/Waveform-installer-64bit-linux-8.2.7.deb";
    sha256  = "0rxgnakv5b4nz6q0swin8ykpvm5mh4q06qypfs3xgcvn8wkygps5";
  };

  nativeBuildInputs = [
    patchelf
  ];

  buildInputs = [
    atk alsaLib freetype curlFull libjack2 libglvnd libX11 libXext  stdenv.cc.cc
  ];

  libPath = stdenv.lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    ar vx ${src}
    tar -xvf data.tar.lzma
  '';

  buildPhase = ''
    echo "pachting binary interpreter"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
        usr/bin/Waveform8
  '';

  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    mv usr/* $out/

    substituteInPlace "$out"/share/applications/waveform8.desktop \
      --replace /usr/bin/Waveform8 $out/bin/Waveform8 
  '';
}
