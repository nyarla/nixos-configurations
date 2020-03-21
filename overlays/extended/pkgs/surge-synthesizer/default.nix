{ stdenv, fetchzip, fetchFromGitHub, gnused, pkgconfig, premake5, cmake, rsync,
  cairo, fontconfig, freetype, xorg, lato, xdg_utils, gnome3,
  libxkbcommon, which, ncurses, utillinux, python3 }:
let
  vst2sdk = fetchzip {
    url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
    sha256 = "1x4qfviwcssk4fswhqks745jicblpy352kd69p7cqmgfcxhckq79";
  };
in stdenv.mkDerivation rec {
  name = "surge-synthesizer-${version}";
  version = "v1.6.5";
  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "release_1.6.5";
    fetchSubmodules = true;
    sha256 = "1gajlncl3pcxw9xii55sn29hf2bwcn6gs7npi4l664pkihnba0mx";
  };

  nativeBuildInputs = [
    pkgconfig premake5 cmake which ncurses utillinux python3 rsync
  ];

  buildInputs = [
    cairo fontconfig freetype lato xdg_utils gnome3.zenity
    libxkbcommon
  ] ++ (with xorg; [
    libX11 libxcb xcbutil xcbutilcursor xcbutilrenderutil xcbutilkeysyms xcbutilimage
  ]);

  postPatch = ''
    sed -i 's|"/usr|"$out|g' build-linux.sh
  '';

  buildPhase = ''
    cp -r ${vst2sdk}/* vst3sdk/

    sh build-linux.sh build --project=vst3
    sh build-linux.sh build --project=lv2
  '';

  installPhase = ''
    mkdir -p $out/lib/vst3
    mkdir -p $out/lib/lv2
    mkdir -p $out/share

    sh build-linux.sh install --project=vst3
    sh build-linux.sh install --project=lv2
  '';
}
