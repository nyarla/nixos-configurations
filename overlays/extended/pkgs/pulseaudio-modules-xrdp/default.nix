{ stdenv, fetchurl, pulseaudioFull }:
stdenv.mkDerivation rec {
  name = "pulseaudio-module-xrdp-${version}";
  version = "0.2";
  src = fetchurl { };

  buildInputs = pulseaudioFull.buildInputs ++ [ pulseaudioFull.dev ];
  nativeBuildInputs = pulseaudioFull.nativeBuildInputs;

  preConfigure = ''
    tar -xvf "${pulseaudioFull.src}" && mv pulseaudio-${pulseaudioFull.version} pulse
    cd pulse
    ${pulseaudioFull.preConfigure}
    ./configure ${
      stdenv.lib.strings.concatStringsSep " " pulseaudioFull.configureFlags
    }
    cd ../

    sed -i "s!AC_PREFIX_PROGRAM(pulseaudio)!!g" configure.ac

    export PULSE_DIR=$(pwd)/pulse
    ./bootstrap
  '';

  preInstall = ''
    sed -i "s!modlibexecdir = .\+\$!modlibexecdir = $out/lib/pulse-${pulseaudioFull.version}/modules\n!g" Makefile
    sed -i "s!modlibexecdir = .\+\$!modlibexecdir = $out/lib/pulse-${pulseaudioFull.version}/modules\n!g" src/Makefile
  '';
}
