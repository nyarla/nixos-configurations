_: self: pkgs:
let
  require = path: pkgs.callPackage (import path);
in
{
  # application wrappers
  amd-run = require ./amd-run { gpuId = null; };
  gimp-shell = require ./gimp-shell { };
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
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  immersed = require ./immersed { };
  sec = require ./sec { };
  thorium-reader = require ./thorium-reader { };
  wcwidth-cjk = require ./wcwidh-cjk { };
  xdg-desktop-portal-hypr-remote = require ./xdg-desktop-portal-hypr-remote { };

  # themes and fonts
  fluent-gtk-theme = require ./fluent-gtk-theme { };
  fluent-kde = require ./fluent-kde { };
  kaunas = require ./kaunas { };
  noto-fonts-jp = require ./noto-fonts-jp { };

  # customized packages
  # calibre = require ./calibre { };
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

  proton-rtsp-wayland-ge-bin = pkgs.proton-ge-bin.overrideAttrs (
    finalAttrs: _: {
      pname = "proton-rstp-wayland-ge";
      version = "Proton-RTSP-Wayland-GE-Beta4";

      inherit (finalAttrs.passthru.variants.${pkgs.stdenvNoCC.hostPlatform.system}) src toolName;

      steamDisplayName = "Proton-RTSP-Wayland-GE";

      preFixup = ''
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "Proton RTSP Wayland GE Beta 4" "${finalAttrs.version}"
      '';

      passthru.variants."x86_64-linux" = {
        toolName = finalAttrs.version;
        src = pkgs.fetchzip {
          url = "https://github.com/Go08er/Proton-RTSP-Wayland-GE/releases/download/v11.1.0-beta.4/Proton-RTSP-Wayland-GE-Beta4.tar.gz";
          hash = "sha256-62UoQEkfhK/EsoQvu2pV6hl1+w9jLkhZWYNm5pvQrSE=";
        };
      };
    }
  );

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

  # webapp
  bookwall = require ./bookwall { };

  # comfyui
  comfyui =
    with pkgs.pkgsRocm;
    callPackage (import ./comfyui) {
      additionalDependencies = with python3.pkgs; [
        gguf
        protobuf
        sentencepiece
      ];
    };

  # custom llama-cpp
  llama-cpp-llm-jp = pkgs.pkgsRocm.llama-cpp.overrideAttrs (finalAttrs: rec {
    pname = "llama-cpp-llm-jp";
    version = "git";

    src = pkgs.fetchFromGitHub {
      owner = "llm-jp";
      repo = "llama.cpp";
      rev = "26b0e874a2893ba36bc2bea526c5a8ab6637ab2a";
      hash = "sha256-3cU/gXRBX3fcLxLA9c16Ko7KYxx59pefxuzMJ9lYrXI=";
    };

    npmRoot = "tools/ui";
    npmDepsHash = "sha256-Iyg8FpcTKf2UYHuK7mA3cTAqVaLcQPcS0YCa5Qf01Gc=";
    npmDeps = pkgs.fetchNpmDeps {
      pname = "${pname}-${version}-npm-deps";
      inherit src;
      inherit (finalAttrs) patches;
      preBuild = ''
        pushd ${npmRoot}
      '';

      hash = npmDepsHash;
    };

    preConfigure = ''
      prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
      pushd ${npmRoot}
      npm run build
      popd
    '';
  });
}
