{ nixpkgs, ... }:
final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  # custom packages
  amd-run = require ./amd-run { gpuId = null; };
  aria-misskey = require ./aria-misskey { };
  audiogridder = require ./audiogridder { };
  cskk = require ./cskk { };
  deadbeef-fb = require ./deadbeef-fb { };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  immersed = require ./immersed { };
  kaunas = require ./kaunas { };
  noise-suppression-for-voice = require ./noise-suppression-for-voice { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  nvidia-maximize = require ./nvidia-maximize { };
  nvim-run = require ./nvim-run { };
  openjtalk = require ./openjtalk { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  rocm-shell = require ./rocm-shell { };
  shoreman = require ./shoreman { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  stability-matrix = require ./stability-matrix { };
  wcwidth-cjk = require ./wcwidh-cjk { };
  xdg-desktop-portal-hypr-remote = require ./xdg-desktop-portal-hypr-remote { };
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

  ollama-rocm = prev.ollama-rocm.override { rocmPackages = prev.rocmPackages.gfx12; };

  speechd-with-openjtalk = prev.speechd.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://github.com/brailcom/speechd/releases/download/0.12.0-rc3/speech-dispatcher-0.12.0-rc3.tar.gz";
      hash = "sha256-vStiv9z3RVKs2F6dpOQv0f8SuOoYYQpqG9aDXfdntmM=";
    };
    buildInputs = old.buildInputs ++ [ final.openjtalk ];
    configureFlags = old.configureFlags ++ [ "--with-openjtalk" ];
  });

  steam = prev.steam.override (
    {
      extraLibraries ? _: [ ],
      ...
    }:
    {
      extraLibraries =
        pkgs':
        (extraLibraries pkgs')
        ++ [
          pkgs'.gperftools
        ];
    }
  );

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

  unityhub-shell = prev.buildFHSEnv {
    name = "unityhub-shell";
    targetPkgs =
      p: with p; [
        unityhub

        fontconfig
        freetype
        gsettings-desktop-schemas
        hicolor-icon-theme
        lsb-release
        xdg-utils
        xorg.libXrandr
      ];
    multiPkgs =
      p: with p; [
        alsa-lib
        at-spi2-core
        atk
        cairo
        clang
        cpio
        cups
        dbus
        expat
        gdk-pixbuf
        git
        glib
        gnome2.GConf
        gtk3
        harfbuzz
        icu
        krb5
        libappindicator
        libcap
        libdrm
        libgbm
        libglvnd
        libnotify
        libpulseaudio
        libsecret
        libuuid
        libva
        libxkbcommon
        libxml2
        lttng-ust_2_12
        nspr
        nss
        openssl
        pango
        udev
        vulkan-loader
        wayland
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libxshmfence
        zlib
        (p.runCommand "libxml2-fake-abi" { } ''
          mkdir -p $out/lib
          ln -s "${pkgs.lib.getLib pkgs.libxml2}/lib/libxml2.so" $out/lib/libxml2.so.2
        '')
      ];

    profile = ''
      export LD_LIBRARY_PATH=/usr/lib
    '';
  };

  weylus = prev.rustPlatform.buildRustPackage rec {
    pname = "weylus";
    version = "2025-02-24";
    src = prev.fetchFromGitHub {
      owner = "H-M-H";
      repo = "Weylus";
      rev = "5202806798ccca67c24da52ba51ee50b973b7089";
      hash = "sha256-lx1ZVp5DkQiL9/vw6PAZ34Lge+K8dfEVh6vLnCUNf7M=";
    };

    patches = [
      ../patches/weylus.patch
    ];

    inherit (prev.weylus)
      nativeBuildInputs
      cargoBuildFlags
      cargoTestFlags
      postInstall
      postFixup
      meta
      ;

    buildInputs =
      prev.weylus.buildInputs
      ++ (with prev; [
        wayland.dev
        libxkbcommon.dev
      ]);

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "autopilot-0.4.0" = "sha256-1DRuhAAXaIADUmXlDVr8UNbI/Ab2PYdrx9Qh0j9rTX8=";
      };
    };
  };

  # custom wine-related packages
  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    paths = prev.lib.makeBinPath [ prev.wineWowPackages.stagingFull ];
  };

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    paths = prev.lib.makeBinPath [
      prev.wineWowPackages.yabridge
      (final.wineasio.override { wine = prev.wineWowPackages.yabridge; })
    ];
  };

  winetricks = prev.winetricks.overrideAttrs (old: {
    pname = "winetricks";
    version = "git";
    src = prev.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "5eed63521781ffc2f0c4bbee7ec9e215b13a1243";
      hash = "sha256-thEL36C2I/l4R5YAyfVg9H3FttsslVRK06Y8rPg+7Do=";
    };
  });

  wineasio = require ./wineasio { };

  carla-with-wine = require ./carla {
    inherit (prev) carla;
    wine = prev.wineWowPackages.yabridge;
  };

  ildaeil = require ./ildaeil {
    carla = final.carla-with-wine;
    wine = prev.wineWowPackages.yabridge;
  };

  wine-vst-wrapper = require ./wine-vst-wrapper {
    wine = prev.wineWowPackages.yabridge;
  };

  yabridge = prev.yabridge.override { wine = prev.wineWowPackages.yabridge; };
  yabridgectl = prev.yabridgectl.override {
    inherit (final) yabridge;
    wine = prev.wineWowPackages.yabridge;
  };
}
