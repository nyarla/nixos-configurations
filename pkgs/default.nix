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
  bitwig-sutido3 = super.bitwig-sutido3.overrideAttrs (old: rec {
    version = "3.3.11";
    src = super.fetchurl {
      url =
        "https://downloads.bitwig.com/stable/${version}/${old.pname}-${version}.deb";
      sha256 = "137i7zqazc2kj40rg6fl6sbkz7kjbkhzdd7550fabl6cz1a20pvh";
    };
  });

  calibre = super.calibre.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.python3Packages.pycrypto ];
  });

  firefox-bin-unwrapped =
    super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = (super.labwc.override { inherit (self) wlroots_0_16; }).overrideAttrs
    (old: rec {
      version = "2022-12-20";
      src = super.fetchFromGitHub {
        owner = "labwc";
        repo = "labwc";
        rev = "cb4afadd0143f599f39603d3685723e16c9df401";
        sha256 = "sha256-Eoc6IwHmJwaSs87L+H1m51YOcQl35n1ZbDxcgP5cwIw=";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
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
    version = "2023-07-08";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "dc25a9cf6816b756cb38490eab93f02589c44a10";
      sha256 = "sha256-0zRmNHya3F4Z0YEOD2Q1sp+X2Qj6gYKP+CdUMwyzojM=";
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

  wineUsingFull = super.wineWowPackages.stagingFull;
}
