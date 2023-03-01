self: super:
let require = path: super.callPackage (import path);
in {
  # additional packages
  arc-openbox = require ./arc-openbox { };
  clipboard-sync = require ./clipboard-sync { };
  cuda-shell = require ./cuda-shell { };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  dexed = require ./dexed { };
  elk-native = require ./elk-native { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-skk = require ./fcitx5-skk { inherit (super.libsForQt5) fcitx5-qt; };
  fedistar = require ./fedistar { };
  flatery-icon-theme = require ./flatery-icon-theme { };
  galendae = require ./galendae { };
  git-credential-keepassxc = require ./git-credential-keepassxc { };
  gyazo-diy = require ./gyazo-diy { };
  hack-nerdfonts = require ./hack-nerdfonts { };
  hackgen = require ./hackgen { };
  jackass-bin = require ./jackass-bin { };
  juce-framework = require ./juce-framework { };
  locale-eaw = require ./locale-eaw { };
  mlterm-wrapped = require ./mlterm-wrapped { inherit (self) mlterm; };
  noto-fonts-jp = require ./noto-fonts-jp { };
  novelai-manager = require ./novelai-manager { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  sfwbar = require ./sfwbar { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  sysmontask = require ./sysmontask { };
  terminfo-mlterm-256color = require ./terminfo-mlterm-256color { };
  tooth = require ./tooth { };
  wayout = require ./wayout { };
  wcwidth-cjk = require ./wcwidth-cjk { };
  wine-run = require ./wine-run { };
  wine-vst-wrapper = require ./wine-vst-wrapper { };
  wineasio = require ./wineasio { };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # modified packages
  calibre = super.calibre.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.python3Packages.pycrypto ];
  });

  ethminer = super.ethminer.override {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };

  fbterm = super.fbterm.overrideAttrs (old: rec {
    patches = old.patches ++ (with super; [
      (fetchpatch {
        url =
          "https://aur.archlinux.org/cgit/aur.git/plain/color_palette.patch?h=fbterm";
        name = "color_palette.patch";
        sha256 = "sha256-SkWxzfapyBTtMpTXkiFHRAw8/uXw7cAWwg5Q3TqWlk8=";
      })
      (fetchpatch {
        url =
          "https://aur.archlinux.org/cgit/aur.git/plain/fbconfig.patch?h=fbterm";
        name = "fbconfig.patch";
        sha256 = "sha256-skCdUqyMkkqxS1YUI7cofsfnNNo3SL/qe4WEIXlhm/s=";
      })
      (fetchpatch {
        url =
          "https://aur.archlinux.org/cgit/aur.git/plain/fbterm.patch?h=fbterm";
        name = "fbterm.patch";
        sha256 = "sha256-XNHBTGQGeaQPip2XgcKlr123VDwils2pnyiGqkBGhzU=";
      })
    ]);
  });

  firefox-bin-unwrapped =
    super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = (super.labwc.override { inherit (self) wlroots_0_16; }).overrideAttrs
    (old: rec {
      version = "2022-12-20";
      src = super.fetchFromGitHub {
        owner = "labwc";
        repo = "labwc";
        rev = "1b30edc778d597e06d74c7fbec62c7a8b13fab4e";
        sha256 = "sha256-3n+nZeH/uruD3vrN+XgnEgyNjgc2g8Og/p1hwskbrd4=";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  libskk = super.libskk.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|"C-j": "set-input-mode-hiragana"|"C-j": "set-input-mode-hiragana", "C-;": "set-input-mode-hiragana"|' rules/default/keymap/latin.json
      sed -i 's|"C-j": "set-input-mode-hiragana"|"C-j": "set-input-mode-hiragana", "C-;": "set-input-mode-hiragana"|' rules/default/keymap/wide-latin.json
    '';
  });

  mlterm = super.mlterm.overrideAttrs (old: rec {
    buildInputs = old.buildInputs
      ++ (with super; [ libxkbcommon SDL2.dev gdk-pixbuf.dev ]);
    configureFlags = (super.lib.remove "--with-gui=xlib,fb" old.configureFlags)
      ++ [ "--with-gui=xlib,fb,wayland,sdl2" ];

    NIX_LDFLAGS = old.NIX_LDFLAGS + ''
      -lm
    '';
  });

  nsfminer = (require ./nsfminer {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  platinum-searcher = super.platinum-searcher.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "monochromegane";
      repo = "the_platinum_searcher";
      rev = "ad20073a3cb5bb354a1fde44ffe5aa331982cbd1";
      sha256 = "sha256-FNHlALFwMbajaHWOehdSFeQmvZSuCZLdqGqLZ7DF+pI=";
    };
  });

  thunderbird-bin-unwrapped =
    super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tt-rss = super.tt-rss.overrideAttrs (old: rec {
    pname = "tt-rss";
    version = "2023-02-03";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "0cd4abe4eb3e1e326a942a2141f118cb3bba9abd";
      sha256 = "sha256-Wz+tO3AKKSWq1YgoisT/8RGFRmQTG8mR3xQWngH4efs=";
    };

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -ra * $out/
      # see the code of Config::get_version(). you can check that the version in
      # the footer of the preferences pages is not UNKNOWN
      echo "22.10" > $out/version_static.txt
      runHook postInstall
    '';
  });

  tt-rss-theme-feedly = super.tt-rss-theme-feedly.overrideAttrs (old: rec {
    version = "2023-02-06";
    src = super.fetchFromGitHub {
      owner = "levito";
      repo = "tt-rss-feedly-theme";
      rev = "5c652126649a4054c8992fc9c0e727a2c03b27e3";
      sha256 = "sha256-z+7pzXRZgMPnE492xFAroeE+vFzDc/4GlkSTMhbq/2I=";
    };
  });

  whalebird = super.whalebird.overrideAttrs (old: rec {
    version = "5.0.0-rc3";
    src = super.fetchurl {
      url =
        "https://github.com/h3poteto/whalebird-desktop/releases/download/v5.0.0-rc.3/Whalebird-5.0.0-rc.3-linux-x64.tar.bz2";
      sha256 = "0md0ip50333nhavz6pg0981ng8rhnf383wyjzf071m4xcg71zp27";
    };

    unpackPhase = ''
      mkdir -p opt
      tar -xf ${src} -C opt
      # remove the version/target suffix from the untar'd directory
      mv opt/Whalebird-* opt/Whalebird
    '';
  });

  wlroots_0_16 = super.wlroots_0_16.overrideAttrs (old: rec {
    version = "0_16_0_mod";
    buildInputs = old.buildInputs
      ++ [ super.mesa.dev super.vulkan-validation-layers ];

    nativeBuildInputs = old.nativeBuildInputs ++ [ super.cmake super.hwdata ];

    patches = [ ../patches/wlroots-workaround.patch ];

    postPatch = ''
      substituteInPlace render/gles2/renderer.c --replace "glFlush();" "glFinish();"
    '';
  });

  xmrig = super.xmrig.override { inherit (super.llvmPackages_14) stdenv; };
  xmrig-cuda = require ./xmrig-cuda {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  };
}
