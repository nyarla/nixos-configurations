self: super:
let require = path: super.callPackage (import path);
in {
  # additional packages
  arc-openbox = require ./arc-openbox { };
  audiogridder = require ./audiogridder { };
  clipboard-sync = require ./clipboard-sync { };
  cuda-shell = require ./cuda-shell {
    cudaPackages = super.cudaPackages_11_8;
    nvidia_x11 = null;
  };
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
  tuba = require ./tuba { };
  vgpu_unlock-rs = require ./vgpu_unlock-rs { };
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

  nsfminer = (require ./nsfminer {
    inherit (super.llvmPackages_14) stdenv;
    inherit (super.cudaPackages) cudatoolkit;
  }).overrideAttrs (old: rec {
    postPatch = old.preConfigure + ''
      sed -i 's/set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -fcolor-diagnostics -Qunused-arguments")//' cmake/EthCompilerSettings.cmake
      sed -i 's|-Wall|-Wall -Ofast -funroll-loops|g' cmake/EthCompilerSettings.cmake
    '';
  });

  platinum-searcher = super.platinum-searcher.overrideAttrs (_: rec {
    src = super.fetchFromGitHub {
      owner = "monochromegane";
      repo = "the_platinum_searcher";
      rev = "ad20073a3cb5bb354a1fde44ffe5aa331982cbd1";
      sha256 = "sha256-FNHlALFwMbajaHWOehdSFeQmvZSuCZLdqGqLZ7DF+pI=";
    };
  });

  thunderbird-bin-unwrapped =
    super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tt-rss = super.tt-rss.overrideAttrs (_: rec {
    pname = "tt-rss";
    version = "2023-05-15";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "a4543de3ac4b8b4e81f317a5ebb0d88004e3884c";
      sha256 = "sha256-m1X0dmTu2aICr31BEsGINKzxNIAvI1nqsqS0GOAfjuc=";
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

  tt-rss-theme-feedly = super.tt-rss-theme-feedly.overrideAttrs (_: rec {
    version = "2023-04-06";
    src = super.fetchzip {
      url =
        "https://github.com/levito/tt-rss-feedly-theme/releases/download/v4.1.0/tt-rss-feedly-theme-dist-4.1.0.zip";
      sha256 = "sha256-u3w92BMuq85SyO3bWRKuA59EaRtehrt02hZY3NMJEOA=";
    };
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
