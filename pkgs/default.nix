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
  elk-native = require ./elk-native { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fedistar = require ./fedistar { };
  flatery-icon-theme = require ./flatery-icon-theme { };
  galendae = require ./galendae { };
  git-credential-keepassxc = require ./git-credential-keepassxc { };
  gyazo-diy = require ./gyazo-diy { };
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

  labwc = (super.labwc.override { wlroots = self.wlroots_0_17; }).overrideAttrs
    (old: rec {
      version = "2023-12-23";
      src = super.fetchFromGitHub {
        inherit (old.src) owner repo;
        rev = "6c287969d3583bb2a3fca444a2abdbb9b5f5a32d";
        hash = "sha256-U+krRZ/b5LHl8+wL/4FN3hM+i5qqxX+QXUvyMP+/d9I=";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  picom-next = super.picom-next.overrideAttrs (old: rec {
    version = "2023-12-23";
    src = super.fetchFromGitHub rec {
      inherit (old.src) owner repo;
      rev = "496452cfce5e002e3795f7b36590af4f10b58798";
      hash = "sha256-bLZnKgTT/L4tI1Z1aO3V2teYTvAof0ndLd3ZD2IaFV0=";
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
    version = "2023-12-03";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "2b8e34453234b8b31ebc9e7020f8677bf3889898";
      hash = "sha256-PLifYhmR8dn+GHc71lrB3asg9nBWJq51/Ap2HlOblYc=";
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

  tt-rss-theme-feedmei = super.stdenvNoCC.mkDerivation rec {
    pname = "feedmei";
    version = "2023-12-23";
    src = super.fetchFromGitea {
      domain = "codeberg.org";
      owner = "ltguillaume";
      repo = "feedmei";
      rev = "6f84582b7b0fb3053ce9b8859b36fe157ae13466";
      hash = "sha256-2YTYN1MQjHIX8+8tegkLgwI6JC0x1qrSrig0UmV9kus=";
    };

    installPhase = ''
      mkdir -p $out/
      cp -R themes.local/* $out/
    '';
  };

  wlroots_0_17 = super.wlroots.overrideAttrs (old: rec {
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "0.17";
      hash = "sha256-Z0gWM7AQqJOSr2maUtjdgk/MF6pyeyFMMTaivgt+RMI=";
    };

    buildInputs = old.buildInputs
      ++ (with super; [ glslang libdrm.dev mesa.dev ]);

    patches = [ ];

    postPatch = ''
      sed -i 's/glFlush/glFinish/' render/gles2/renderer.c
    '';
  });

  wineUsingFull = super.lib.overrideDerivation super.wineWowPackages.stagingFull
    (old: rec {
      buildInputs = old.buildInputs ++ (with super; [ libgcrypt.dev libva.dev ])
        ++ (with super.pkgsi686Linux; [ libgcrypt.dev libva.dev ]);

      configureFlags = old.configureFlags
        ++ [ "--with-va" "--with-gcrypt" "--disable-test" ];
    });
  #wineUsingFull = super.wineWowPackages.stagingFull;
}
