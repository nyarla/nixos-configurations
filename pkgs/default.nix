{ nixpkgs, ... }:
final: prev:
let
  require = path: prev.callPackage (import path);
in
{
  # custom packages
  amd-run = require ./amd-run { gpuId = null; };
  aria-misskey = require ./aria-misskey { };
  calibre = require ./calibre { inherit (prev) calibre; };
  cskk = require ./cskk { };
  deadbeef-fb = require ./deadbeef-fb { };
  fluent-kde = require ./fluent-kde { };
  galendae = require ./galendae { };
  ghalint = require ./ghalint { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  immersed = require ./immersed { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  nvim-run = require ./nvim-run { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  rocm-shell = require ./rocm-shell { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  thorium-reader = require ./thorium-reader { };
  unityhub-amd = require ./unityhub-amd { };
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

  # customized packages
  firefox-bin-unwrapped = prev.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

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
      cp ${../patches/tmux-3.6-utf8.h} utf8_default_width_cache.h
    '';
    patches = [ ../patches/tmux-3.6-utf8.patch ];
  });

  # custom wine-related packages
  carla-with-wine = require ./carla {
    wine = prev.wineWowPackages.yabridge;
  };

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    paths = prev.lib.makeBinPath [ prev.wineWowPackages.yabridge ];
  };

  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    paths = prev.lib.makeBinPath [ prev.wineWowPackages.stagingFull ];
  };

  winetricks = prev.winetricks.overrideAttrs (old: {
    pname = "winetricks";
    version = "git";
    src = prev.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "533f41704766765cfb3706fb2aa197acbb05df32";
      hash = "sha256-Bt5wo7zEAN9Mh9dwbGPsSW8pt1ruBrn0Br9BdprtIRY=";
    };
  });

  wineasio = require ./wineasio { };
}
