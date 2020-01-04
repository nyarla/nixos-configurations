{ stdenv, fetchurl, p7zip }:
stdenv.mkDerivation rec {
  name = "genjyuu-gothic-${version}";
  version = "2015-06-07"; 
  srcs = [
    (fetchurl { url = "http://iij.dl.osdn.jp/users/8/8636/genjyuugothic-20150607.7z";     sha256 = "1ns97qn8hb2iy8qbirgcg3waxzg3j6f80yksxbicjnlqa5iqg5qr"; })
    (fetchurl { url = "https://ymu.dl.osdn.jp/users/8/8638/genjyuugothic-x-20150607.7z";  sha256 = "0yh3z3kqbgy2xxvr2bfkrfmw2yvxkknivj47yvj6jq06y2ynffam"; })
    (fetchurl { url = "http://iij.dl.osdn.jp/users/8/8635/genjyuugothic-l-20150607.7z";   sha256 = "1fvcyy36adcpd1bzwcjhrvg8csj4fizybl19p4hyi5ryg2jhg039"; })
  ];

  unpackPhase = ''
    ${stdenv.lib.strings.concatMapStrings (file: ''
      ${p7zip}/bin/7z x -y ${file} 
    '') srcs}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/genjyuu
    cp *.ttf $out/share/fonts/truetype/genjyuu/
  '';
}
