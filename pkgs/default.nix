{ nixpkgs, ... }:
final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  # additional packages
  aria-misskey = require ./aria-misskey { };
  audiogridder = require ./audiogridder { };
  cskk = require ./cskk { };
  cuda-shell = require ./cuda-shell {
    cudaPackages = prev.cudaPackages_11_8;
    nvidia_x11 = null;
  };
  currennt = require ./currennt { inherit (prev.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = prev.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt5 = prev.libsForQt5.callPackage (import ./fcitx5-cskk) { enableQt = true; };
  fcitx5-cskk-qt6 = prev.kdePackages.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = true;
  };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  kaunas = require ./kaunas { };
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

  bitwig-studio3 = prev.bitwig-studio3.override {
    libjack2 = prev.pipewire.jack;
  };

  calibre = prev.calibre.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ prev.python3Packages.pycrypto ];
    disabledTests = [
      "test_fts_search"
      "test_fts_pool"
      "test_export_import"
    ];
  });

  firefox-bin-unwrapped = prev.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  flaresolverr = require ./flaresolverr-21hsmw { };

  labwc = prev.labwc.overrideAttrs (_: {
    # 2025-02-03
    src = prev.fetchFromGitHub {
      owner = "labwc";
      repo = "labwc";
      rev = "ed4553fc7e36175fa160fd50914224da00fb1181";
      hash = "sha256-DBtnJ/uR5U6BvrrnKGVw80m7D0KZpithhwLRiiZu5dQ=";
    };
    patches = [
      (prev.fetchpatch {
        name = "text-input-v1.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-IME-support-text-input-v1.patch?h=labwc-im&id=54103c35c0e8859317e7455204d78fb606c494f9";
        hash = "sha256-WJnbd6DXSYSccvyLiLIswpC3uBzsvGZ4BX8mxUl2b7Q=";
      })
    ];
  });

  looking-glass-client =
    (prev.looking-glass-client.override { stdenv = prev.gcc13Stdenv; }).overrideAttrs
      (_: {
        version = "bleeding-edge";
        src = prev.fetchFromGitHub {
          owner = "gnif";
          repo = "LookingGlass";
          rev = "e25492a3a36f7e1fde6e3c3014620525a712a64a";
          hash = "sha256-DBmCJRlB7KzbWXZqKA0X4VTpe+DhhYG5uoxsblPXVzg=";
          fetchSubmodules = true;
        };
        patches = [ ];
      });

  mlterm = prev.mlterm.override {
    stdenv = prev.gcc13Stdenv;
    enableGuis = {
      xlib = true;
      fb = true;
      quartz = false;
      wayland = true;
      sdl2 = true;
    };
    enableFeatures = {
      uim = false;
      ibus = true;
      fcitx = true;
      m17n = true;
      ssh2 = true;
      bidi = true;
      otl = true;
    };
  };

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

  waybar = prev.waybar.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      prev.libnotify.dev
      prev.upower.dev
    ];
    nativeBuildInputs = old.nativeBuildInputs ++ [ prev.cmake ];
  });

  weylus = prev.weylus.overrideAttrs (_: rec {
    src = prev.fetchFromGitHub {
      owner = "H-M-H";
      repo = "Weylus";
      rev = "d30b8b3e56820b72a858e227654823722f0d5d8f";
      hash = "sha256-TpCUtrk2oqjB0CEWy96fSz1w1HjZrwEVqwVqlWqkQD8=";
    };

    patches = [
      ../patches/weylus.patch
    ];

    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = src + /Cargo.lock;
      outputHashes = {
        "autopilot-0.4.0" = "sha256-1DRuhAAXaIADUmXlDVr8UNbI/Ab2PYdrx9Qh0j9rTX8=";
      };
    };
  });

  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    wine = prev.wineWowPackages.stagingFull;
  };

  # custom wine-related packages
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

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    wine = final.wine-vst;
  };

  carla = require ./carla {
    inherit (prev) carla;
    wine = final.wine-vst;
  };

  ildaeil = require ./ildaeil {
    inherit (final) carla;
    wine = final.wine-vst;
  };

  wineasio = require ./wineasio {
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
