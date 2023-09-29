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
  fedistar = require ./fedistar { };
  flatery-icon-theme = require ./flatery-icon-theme { };
  galendae = require ./galendae { };
  git-credential-keepassxc = require ./git-credential-keepassxc { };
  gyazo-diy = require ./gyazo-diy { };
  hack-nerdfonts = require ./hack-nerdfonts { };
  ildaeil = require ./ildaeil { inherit (self) carla; };
  jackass-bin = require ./jackass-bin { };
  juce-framework = require ./juce-framework { };
  kaunas = require ./kaunas { };
  locale-eaw = require ./locale-eaw { };
  mlterm-wrapped = require ./mlterm-wrapped { inherit (self) mlterm; };
  noto-fonts-jp = require ./noto-fonts-jp { };
  novelai-manager = require ./novelai-manager { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  sysmontask = require ./sysmontask { };
  tabby = require ./tabby { nvidia_x11 = null; };
  terminfo-mlterm-256color = require ./terminfo-mlterm-256color { };
  turbopilot = require ./turbopilot { nvidia_x11 = null; };
  vgpu_unlock-rs = require ./vgpu_unlock-rs { };
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

  carla = require ./carla {
    inherit (super) carla;
    wine = self.wineUsingFull;
  };

  firefox-bin-unwrapped =
    super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = (super.labwc.override { wlroots = self.wlroots_0_16; }).overrideAttrs
    (old: rec {
      version = "2023-09-05";
      src = super.fetchFromGitHub {
        inherit (old.src) owner repo;
        rev = "143714f1c9c2821ca70ef26949395557b15e2171";
        hash = "sha256-hUi5mKDLU7L33h4BMyOuzSbFVOhySKzWooPQet31fm0=";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  picom-next = super.picom-next.overrideAttrs (old: rec {
    version = "2023-09-16";
    src = super.fetchFromGitHub rec {
      inherit (old.src) owner repo;
      rev = "8cc5090a6c3b04db74f41d1108bd19d2592fa9ad";
      hash = "sha256-Alri5KQ1ps5ZUN1lwGisDkZjU4v6u2yD2jgpZAY047Q=";
    };
    buildInputs = old.buildInputs ++ [ super.xorg.xcbutil ];
  });

  platinum-searcher = super.platinum-searcher.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "ad20073a3cb5bb354a1fde44ffe5aa331982cbd1";
      sha256 = "sha256-FNHlALFwMbajaHWOehdSFeQmvZSuCZLdqGqLZ7DF+pI=";
    };
  });

  sfwbar = super.sfwbar.overrideAttrs (old: rec {
    nativeBuildInputs = old.nativeBuildInputs ++ [ super.wrapGAppsHook ];
  });

  thunderbird-bin-unwrapped =
    super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tt-rss = super.tt-rss.overrideAttrs (_: rec {
    pname = "tt-rss";
    version = "2023-08-03";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "03526d8151552e751b24b599fabdd399c6e27ef3";
      hash = "sha256-R5HCMY4t8wFwgSiHy9In/eSJPkCoNwEx4g78A2PPXks=";
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
    version = "4.1.0";
    src = super.fetchzip {
      url =
        "https://github.com/levito/tt-rss-feedly-theme/releases/download/v${version}/tt-rss-feedly-theme-dist-${version}.zip";
      sha256 = "sha256-u3w92BMuq85SyO3bWRKuA59EaRtehrt02hZY3NMJEOA=";
    };
  });

  wlroots_0_16 = super.wlroots_0_16.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ (with super; [
      glslang
      libdrm.dev
      mesa.dev
      vulkan-validation-layers.headers
    ]);

    nativeBuildInputs = old.nativeBuildInputs ++ (with super; [ hwdata ]);
    postPatch = ''
      sed -i 's/glFlush/glFinish/' render/gles2/renderer.c
    '';
    patches = [ ../patches/wlroots-workaround.patch ];
  });

  wineUsingFull =
    super.lib.overrideDerivation super.wineWowPackages.unstableFull (old: rec {
      pname = "proton-wine";
      version = "GE-Proton8-15";

      name = "${pname}-${version}";

      src = super.fetchFromGitHub {
        owner = "GloriousEggroll";
        repo = pname;
        rev = version;
        hash = "sha256-a8KPtrRttiSLB9Q31GBdCcYW0xxEzjteOlXpv7OECuo=";
      };
      configureFlags = old.configureFlags ++ [ "--disable-tests" ];
      patches = [ ];
    });
}
