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

  # add GPU (cuda) support to VoiceVox
  voicevox-core =
    let
      cudaPackages = prev.cudaPackages_11_8;
      # this is workaround for build failure by broken symlinks
      tensorrt = cudaPackages.tensorrt_8_6.overrideAttrs (old: {
        outputs = [ "out" ];
        dontCheckForBrokenSymlinks = true;
        fixupPhase = ''
          ${old.fixupPhase or ""}
          find $out -type l ! -exec test -e \{} \; -delete || true
        '';
      });
    in
    prev.voicevox-core.overrideAttrs (old: {
      src = prev.fetchurl {
        # fetch pre-built binary with GPU supported
        url = "https://github.com/VOICEVOX/voicevox_core/releases/download/${old.version}/voicevox_core-linux-x64-gpu-${old.version}.zip";
        sha256 = "0hcfk9d9vahwkhh6wlvh5dgzlw1bsl2dpk1b2iqgvfxvv3cbprkf";
      };

      # add additional dependencies
      buildInputs =
        old.buildInputs
        ++ (with prev; [
          zlib
        ])
        ++ (with cudaPackages; [
          cuda_cudart.lib
          cudatoolkit.lib
          cudnn_8_9.lib
          libcublas.lib
          tensorrt
        ]);

      # this is required by link libnv* library to pre-built binaries
      extraAutoPatchelfLibs = [ "${tensorrt}/lib/stubs" ];

      postInstall = ''
        install -Dm755 libonnxruntime_* $out/lib
      '';

      preFixup = ''
        # this is workaround for libonnxruntime_providers_tensorrt.so has not dependencies as elf's `needed`
        patchelf --add-needed libcublasLt.so.11 $out/lib/libonnxruntime_providers_tensorrt.so
        patchelf --add-needed libcublas.so.11 $out/lib/libonnxruntime_providers_tensorrt.so
      '';
    });

  voicevox-engine = prev.voicevox-engine.overrideAttrs (old: {
    # if LD_LIBRARY_PATH is not set, voicevox-engine failed to find shared libraries
    makeWrapperArgs = old.makeWrapperArgs ++ [
      ''--set LD_LIBRARY_PATH ${final.voicevox-core}/lib''
    ];
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

  wineasio =
    let
      mkJack2 =
        pkgs:
        pkgs.libjack2.overrideAttrs (self: {
          postFixup =
            self.postFixup
            + ''
              chmod +w $out/lib
              cp -Pp ${pkgs.pipewire.jack}/lib/* $out/lib/
            '';
        });
    in
    require ./wineasio {
      wine = final.wine-vst;
      libjack2 = mkJack2 prev;
      pkgsi686Linux = {
        libjack2 = prev.pkgsi686Linux.pipewire.jack;
      };
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
