_: _: pkgs:
let
  require = path: pkgs.callPackage (import path);
in
{
  # application wrappers
  amd-run = require ./amd-run { gpuId = null; };
  nvim-run = require ./nvim-run { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  rocm-shell = require ./rocm-shell { };
  sandboxed-commands = require ./sandboxed-commands { };
  unityhub-amd = require ./unityhub-amd { };

  # custom defined packages
  aria-misskey = require ./aria-misskey { };
  deadbeef-fb = require ./deadbeef-fb { };
  flare-app = require ./flare-app { };
  galendae = require ./galendae { };
  ghalint = require ./ghalint { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  immersed = require ./immersed { };
  sec = require ./sec { };
  thorium-reader = require ./thorium-reader { };
  wcwidth-cjk = require ./wcwidh-cjk { };
  xdg-desktop-portal-hypr-remote = require ./xdg-desktop-portal-hypr-remote { };

  # themes and fonts
  fluent-kde = require ./fluent-kde { };
  kaunas = require ./kaunas { };
  noto-fonts-jp = require ./noto-fonts-jp { };

  # customized packages
  calibre = require ./calibre { };
  glibc-locales-eaw = require ./glibc-locales-eaw { };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  tmux = pkgs.tmux.overrideAttrs (_: {
    preConfigure = ''
      cp ${../patches/tmux-3.6-utf8.h} utf8_default_width_cache.h
    '';
    patches = [ ../patches/tmux-3.6-utf8.patch ];
  });

  # internet
  firefox-bin-unwrapped = pkgs.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };
  thunderbird-bin-unwrapped = pkgs.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  # gaming
  steam = pkgs.steam.override {
    extraProfile = ''
      unset TZ
    '';
  };

  # inupts methods
  cskk = require ./cskk { };
  skk-dicts-xl = require ./skk-dicts-xl { };

  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = pkgs.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt5 = pkgs.libsForQt5.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = false;
  };
  fcitx5-cskk-qt6 = pkgs.qt6Packages.callPackage (import ./fcitx5-cskk) {
    enableQt = true;
    useQt6 = true;
  };

  # creative softwares
  chipsynth = {
    sfc = require ./chipsynth/sfc.nix { };
  };
  sononym-bin = require ./sononym-bin { };

  carla-with-wine = require ./carla {
    wine = pkgs.wineWow64Packages.yabridge;
  };

  ildaeil = require ./ildaeil {
    wine = pkgs.wineWow64Packages.yabridge;
  };

  wine-vst-run = require ./wine-run {
    pname = "wine-vst";
    paths = pkgs.lib.makeBinPath [ pkgs.wineWow64Packages.yabridge ];
  };

  wine-staging-run = require ./wine-run {
    pname = "wine-staging";
    paths = pkgs.lib.makeBinPath [ pkgs.wineWow64Packages.stagingFull ];
  };

  wineasio = require ./wineasio { };

  # comfyUI
  comfyui = require ./comfyui {
    additionalDependencies = with pkgs.python3.pkgs; [
      gguf
      sentencepiece
      protobuf
    ];
  };
}
