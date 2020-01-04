{ stdenv, fetchurl }:
let
  fonts = [
    { name = "NotoSansJP-Black";          sha256 = "1mxfi76g2bdbjwg7370ms2ifq53lvzrnf7kkk47928yljdd1z2i5"; }
    { name = "NotoSansJP-Bold";           sha256 = "0kr2fic5j9h6i7f3yqwck5lcxnfcv0amsw03kx7bgh3jcdjid1h4"; }
    { name = "NotoSansJP-DemiLight";      sha256 = "13kclx4p7vrn399hdivns0fwh7f8d150gjhl1xkmlxl128bz4ln0"; }
    { name = "NotoSansJP-Light";          sha256 = "04aaq4m76a76i0j0ngza9zafhnlm687cv5pij5dqlg4fg721fkcf"; }
    { name = "NotoSansJP-Medium";         sha256 = "1ply2zzp1z26caclwqbz3hmp6kvg3l8w9y3y6isn1sdmk8r8anx6"; }
    { name = "NotoSansJP-Regular";        sha256 = "19k1n95mipkzkzkx0ivqssca6b5m7sjyvzq46gjnmg76h6brrcwv"; }
    { name = "NotoSansJP-Thin";           sha256 = "1ndrnbf1cyjqgs61yypb71cni00ypr950qr4ri218dx4zlxx1d2w"; }

    { name = "NotoSansMonoCJKjp-Bold";    sha256 = "0vdqyvqvaj7jda0rr1bz7a05wjs1s08d4jippaffvrikhwnxpsly"; }
    { name = "NotoSansMonoCJKjp-Regular"; sha256 = "0wlrw6aclgg6fgz01vn55rf8jw0zban1zv114slv53qr1qlwrfva"; }

    { name = "NotoSerifJP-Black";         sha256 = "0h4s9k245cbjylvnlm1y3xnbd5sk2yjf66d6dqcxrfrbwnw3ljc2"; }
    { name = "NotoSerifJP-Bold";          sha256 = "10r489hm09qn3l4cj40qmpgqijrbfhwmhfirzdh321cnhi26gyrn"; }
    { name = "NotoSerifJP-ExtraLight";    sha256 = "0nfvbxcmhpbjz516x8l804py63gcqxhn2hn2cxkp3mgsklqzzwfp"; }
    { name = "NotoSerifJP-Light";         sha256 = "0pl8bq3axlbjr6il2gjf27bg68r36p5k60v4fk0p6hp7wpqrq313"; }
    { name = "NotoSerifJP-Medium";        sha256 = "1cbxml3ih4hpmdhz4zdccw59xni89ahx63wlc0iz5m055cylvlga"; }
    { name = "NotoSerifJP-Regular";       sha256 = "17cdbbgda7d635qc5wschb95lgkn1xsnyb6m3j8gfy9rvvf7aa51"; }
    { name = "NotoSerifJP-SemiBold";      sha256 = "1l1zf1gf9g5s7sy3awfd9r4vdd81r0ignpixm4x525rpq6qki2jd"; }
  ];


in stdenv.mkDerivation rec {
  version = "V2.0001";
  name    = "noto-fonts-jp-${version}";

  files = map ({ name, sha256 }: fetchurl {
    url = "https://raw.githubusercontent.com/googlefonts/noto-cjk/master/${name}.otf";
    inherit sha256;
  }) fonts;

  unpackPhase = ''
    mkdir -p noto

    ${stdenv.lib.strings.concatMapStrings (font: ''
      cp ${font} noto  
    '') files}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/
    mv noto $out/share/fonts/
  '';

  meta = with stdenv.lib; {
    description = "Beautiful and free fonts for CJK languages";
    homepage = https://www.google.com/get/noto/help/cjk/;
    longDescription =
    ''
      Noto Sans CJK is a sans serif typeface designed as an intermediate style
      between the modern and traditional. It is intended to be a multi-purpose
      digital font for user interface designs, digital content, reading on laptops,
      mobile devices, and electronic books. Noto Sans CJK comprehensively covers
      Simplified Chinese, Traditional Chinese, Japanese, and Korean in a unified font
      family. It supports regional variants of ideographic characters for each of the
      four languages. In addition, it supports Japanese kana, vertical forms, and
      variant characters (itaiji); it supports Korean hangeul — both contemporary and
      archaic.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainer = [ "nyarla <nyarla@thotp.net>" ];
  };
}

