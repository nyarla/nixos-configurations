_: final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  # custom packages
  amd-run = require ./amd-run { gpuId = null; };
  aria-misskey = require ./aria-misskey { };
  calibre = require ./calibre { };
  cskk = require ./cskk { };
  deadbeef-fb = require ./deadbeef-fb { };
  flare-app = require ./flare-app { };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  ghalint = require ./ghalint { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  immersed = require ./immersed { };
  kaunas = require ./kaunas { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  nvim-run = require ./nvim-run { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  rocm-shell = require ./rocm-shell { };
  sandboxed-commands = require ./sandboxed-commands { };
  sec = require ./sec { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  thorium-reader = require ./thorium-reader { };
  unityhub-amd = require ./unityhub-amd { };
  wcwidth-cjk = require ./wcwidh-cjk { };
  xdg-desktop-portal-hypr-remote = require ./xdg-desktop-portal-hypr-remote { };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # chipsynth
  chipsynth = {
    sfc = require ./chipsynth/sfc.nix { };
  };

  # fcitx5 packages
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = prev.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt5 = prev.libsForQt5.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = false;
  };
  fcitx5-cskk-qt6 = prev.qt6Packages.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = true;
  };

  # customized packages
  firefox-bin-unwrapped = prev.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  gemini-cli-pinned = prev.gemini-cli.overrideAttrs (finalAttrs: rec {
    pname = "gemini-cli-pinned";
    version = "0.38.2";
    src = prev.fetchFromGitHub {
      inherit (finalAttrs.src) owner repo;
      rev = "v${version}";
      hash = "sha256-DPJMpm+hOQQxG87/NyrCrlomeR4AD1WNfNoIsdaakaE=";
    };

    npmDeps = prev.fetchNpmDeps {
      inherit src;
      inherit (finalAttrs) postPatch;
      hash = "sha256-6UnLSmKdnXwEXgGcyRTibDkEqvlRr75e3fRld0v6T2s=";
    };
  });

  labwc-git =
    (prev.labwc.override { wlroots_0_19 = final.wlroots_0_20_1; }).overrideAttrs
      (finalAttrs: {
        inherit (finalAttrs) pname;
        version = "0.9.5";
        src = prev.fetchFromGitHub {
          owner = "labwc";
          repo = "labwc";
          rev = "bce14a5ad7981e9ab99dc5b75a922438930ff39b";
          hash = "sha256-c7ZmnAV53CouHBGiz2HlOolr31zq/jG410EDcQCXlHU=";
        };

        mesonFlags = (finalAttrs.mesonFlags or [ ]) ++ [
          "-Dsystemd-session=disabled"
        ];
      });

  steam = prev.steam.override {
    extraProfile = ''
      unset TZ
    '';
  };

  thunderbird-bin-unwrapped = prev.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tmux = prev.tmux.overrideAttrs (_: {
    preConfigure = ''
      cp ${../patches/tmux-3.6-utf8.h} utf8_default_width_cache.h
    '';
    patches = [ ../patches/tmux-3.6-utf8.patch ];
  });

  wlroots_0_20_1 = prev.wlroots_0_20.overrideAttrs (finalAttrs: {
    inherit (finalAttrs) pname;
    version = "0.20.1";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "a7f20066270c042799ae70b71dfa4d561ba85121";
      hash = "sha256-uuc1dn13FXvFSBvE3+QOi35rLJZmWIUst64oaXGdPFk=";
    };
  });

  # custom wine-related packages
  carla-with-wine = require ./carla {
    wine = prev.wineWow64Packages.yabridge;
  };

  ildaeil = require ./ildaeil {
    wine = prev.wineWow64Packages.yabridge;
  };

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    paths = prev.lib.makeBinPath [ prev.wineWow64Packages.yabridge ];
  };

  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    paths = prev.lib.makeBinPath [ prev.wineWow64Packages.stagingFull ];
  };

  wineasio = require ./wineasio { };
}
