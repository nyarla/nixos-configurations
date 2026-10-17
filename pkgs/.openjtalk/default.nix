{
  stdenv,
  stdenvNoCC,
  fetchurl,
}:
let
  htsengine = stdenv.mkDerivation rec {
    pname = "hts_engine";
    version = "1.10";
    src = fetchurl {
      url = "mirror://sourceforge/hts-engine/hts_engine_API-${version}.tar.gz";
      hash = "sha256-4hMr5YYNj7SkYL52ZFTP18PiHPZ7UJxI4YBP6rFJaPc=";
    };
  };

  open-jtalk-mecab-naist-jdic-utf8 = stdenvNoCC.mkDerivation rec {
    pname = "open-jtalk-mecab-naist-jdic-utf-8";
    version = "1.11";
    src = fetchurl {
      url = "mirror://sourceforge/open-jtalk/open_jtalk_dic_utf_8-${version}.tar.gz";
      hash = "sha256-M+nNJRvEGqK9fKNvV6u/YerjVDyiXKiSrjReOUyxBUk=";
    };

    installPhase = ''
      mkdir -p $out/share/openjtalk/dict
      cp -r . $out/share/openjtalk/dict
    '';
  };

  hts-voice-nitech-jp-atr503-m001 = stdenvNoCC.mkDerivation rec {
    pname = "hts_voice_nitech_jp_atr503_m001";
    version = "1.05";
    src = fetchurl {
      url = "mirror://sourceforge/open-jtalk/hts_voice_nitech_jp_atr503_m001-${version}.tar.gz";
      hash = "sha256-LlVciEgiZ7KTHH28fswOPfFA1vaPyROqSCLzNsngrfw=";
    };

    installPhase = ''
      mkdir -p $out/share/openjtalk/voice
      cp -r . $out/share/openjtalk/voice
    '';
  };

  openjtalk = stdenv.mkDerivation rec {
    pname = "openjtalk";
    version = "1.11";
    src = fetchurl {
      url = "mirror://sourceforge/open-jtalk/open_jtalk-${version}.tar.gz";
      hash = "sha256-IP3GrrbHV4ZgNKvBdYIFc9tD5ChHB8hm/NAsjsGN5x8=";
    };

    buildInputs = [ htsengine ];
    configureFlags = [
      "--with-hts-engine-header-path=${htsengine}/include"
      "--with-hts-engine-library-path=${htsengine}/lib"
    ];

    passthru = {
      inherit htsengine open-jtalk-mecab-naist-jdic-utf8 hts-voice-nitech-jp-atr503-m001;
    };
  };
in
openjtalk
