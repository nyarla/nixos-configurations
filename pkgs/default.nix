{ nixpkgs, ... }:
final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  # custom packages
  aria-misskey = require ./aria-misskey { };
  audiogridder = require ./audiogridder { };
  cskk = require ./cskk { };
  deadbeef-fb = require ./deadbeef-fb { };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  kaunas = require ./kaunas { };
  noise-suppression-for-voice = require ./noise-suppression-for-voice { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  nvim-run = require ./nvim-run { };
  openjtalk = require ./openjtalk { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  shoreman = require ./shoreman { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  stability-matrix = require ./stability-matrix { };
  wcwidth-cjk = require ./wcwidh-cjk { };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # fcitx5 packages
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = prev.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt5 = prev.libsForQt5.callPackage (import ./fcitx5-cskk) { enableQt = true; };
  fcitx5-cskk-qt6 = prev.qt6Packages.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = true;
  };

  # cuda-related packages
  cuda-shell = require ./cuda-shell {
    inherit (prev) cudaPackages;
    nvidia_x11 = null;
  };
  currennt = require ./currennt { inherit (prev.cudaPackages) cudatoolkit; };

  # customized packages
  bitwig-studio3 = prev.bitwig-studio3.override {
    libjack2 = prev.pipewire.jack;
  };

  calibre = prev.calibre.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.python3Packages.pycrypto ];
    doInstallCheck = false;
  });

  firefox-bin-unwrapped = prev.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = prev.labwc.overrideAttrs (_: {
    patches = [
      (prev.fetchpatch {
        name = "text-input-v1.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-IME-support-text-input-v1.patch?h=labwc-im&id=62363809aff2bfdf032942bb0f0e6ca926cda5f6";
        sha256 = "1r5rpxzgzynjbpfws6ji2s2sdg68riyq205n216hzkcqazgmddzg";
      })
    ];
  });

  pixelorama = prev.pixelorama.overrideAttrs (old: {
    runtimeDependencies = old.runtimeDependencies ++ prev.godot_4.runtimeDependencies;
  });

  speechd-with-openjtalk = prev.speechd.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://github.com/brailcom/speechd/releases/download/0.12.0-rc3/speech-dispatcher-0.12.0-rc3.tar.gz";
      hash = "sha256-vStiv9z3RVKs2F6dpOQv0f8SuOoYYQpqG9aDXfdntmM=";
    };
    buildInputs = old.buildInputs ++ [ final.openjtalk ];
    configureFlags = old.configureFlags ++ [ "--with-openjtalk" ];
  });

  thunderbird-bin-unwrapped = prev.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tmux = prev.tmux.overrideAttrs (_: {
    preConfigure = ''
      cp ${../patches/utf8_force_wide.h} utf8_force_wide.h
    '';
    patches = [ ../patches/tmux3.5a-utf8.patch ];
  });

  tunefish = prev.tunefish.overrideAttrs (_: {
    src = prev.fetchFromGitHub {
      owner = "paynebc";
      repo = "tunefish";
      rev = "7e48ce8683155d5c37eb317b7ed509481c76a352";
      hash = "sha256-oY8+hgn5eJuEgTAlGsAnGiGsD+PE5l5hbMFpsWBhlY0=";
    };

    CFLAGS = "-I${prev.vst2-sdk}";

    installPhase = ''
      mkdir -p $out/lib/vst
      mkdir -p $out/lib/vst3

      cp src/tunefish4/Builds/LinuxMakefile/build/Tunefish4.so \
        $out/lib/vst/

      cp -r src/tunefish4/Builds/LinuxMakefile/build/Tunefish4.vst3 \
        $out/lib/vst3/Tunefish4.vst3
    '';
  });

  # custom wine-related packages
  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    paths = prev.lib.makeBinPath [ prev.wineWowPackages.stagingFull ];
  };

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    paths = prev.lib.makeBinPath [ final.wine-vst ];
  };

  wineasio = require ./wineasio { };

  wine-vst = require ./wine-runtime {
    inherit nixpkgs;

    pname = "wine-vst";
    version = "9.21";
    src = prev.fetchurl {
      url = "https://dl.winehq.org/wine/source/9.x/wine-9.21.tar.xz";
      sha256 = "1zrgra4ajxaic1ga4yfvv4lxix76sigysdhf21bs8blvzmzv8hj4";
    };

    staging = prev.fetchFromGitLab {
      domain = "gitlab.winehq.org";
      owner = "wine";
      repo = "wine-staging";
      rev = "v9.21";
      hash = "sha256-FDNszRUvM1ewE9Ij4EkuihaX0Hf0eTb5r7KQHMdCX3U=";
    };
  };

  carla = require ./carla {
    inherit (prev) carla;
    wine = final.wine-vst;
  };

  ildaeil = require ./ildaeil {
    inherit (final) carla;
    wine = final.wine-vst;
  };

  wine-vst-wrapper = require ./wine-vst-wrapper {
    wine = final.wine-vst;
  };

  yabridge = prev.yabridge.override { wine = final.wine-vst; };
  yabridgectl = prev.yabridgectl.override {
    inherit (final) yabridge;
    wine = final.wine-vst;
  };
}
