self: super:
let require = path: super.callPackage (import path);
in {
  # additional packages
  arc-openbox = require ./arc-openbox { };
  audiogridder = require ./audiogridder { };
  clipboard-sync = require ./clipboard-sync { };
  cskk = require ./cskk { };
  cuda-shell = require ./cuda-shell {
    cudaPackages = super.cudaPackages_11_8;
    nvidia_x11 = null;
  };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  elk-native = require ./elk-native { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = super.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt = self.fcitx5-cskk.override { enableQt = true; };
  fedistar = require ./fedistar { };
  flatery-icon-theme = require ./flatery-icon-theme { };
  galendae = require ./galendae { };
  git-credential-keepassxc = require ./git-credential-keepassxc { };
  gyazo-diy = require ./gyazo-diy { };
  ildaeil = require ./ildaeil {
    inherit (self) carla;
    wine = self.wineUsingFull;
  };
  jackass-bin = require ./jackass-bin { wine = self.wineUsingFull; };
  juce-framework = require ./juce-framework { };
  kaunas = require ./kaunas { };
  locale-eaw = require ./locale-eaw { };
  mlterm-wrapped = require ./mlterm-wrapped { inherit (self) mlterm; };
  nvim-run = require ./nvim-run { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  novelai-manager = require ./novelai-manager { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  shoreman = require ./shoreman { };
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
  wineasio = require ./wineasio { wine = self.wineUsingFull; };
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
      version = "2024-03-18";
      src = super.fetchFromGitHub {
        inherit (old.src) owner repo;
        rev = "9d51107166b584d35a14d4f769c90f64fb420e87";
        hash = "sha256-RuWcp/1z3BVmuZ0b/7bfe5f3Dyjfda1rlOxZjigO9PM=";
      };
      buildInputs = old.buildInputs ++ [ super.xorg.xcbutilwm ];
    });

  picom-next = super.picom-next.overrideAttrs (old: rec {
    version = "2024-03-13";
    src = super.fetchFromGitHub rec {
      inherit (old.src) owner repo;
      rev = "f7e538fe887ca96bbcf6549376ccf502f62a54c6";
      hash = "sha256-eu7Zz/pWNWNdH4FUzdtTRsD/yD2vhWBfzewY6LE3UYo=";
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

  tmux = super.tmux.overrideAttrs (old: rec {
    patches = old.patches ++ [
      (super.fetchpatch {
        url =
          "https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-3.4-fix.diff";
        sha256 = "0fhbgxsbg207vzm7lbkslwwpxpgmv2b2va9jbv1gphyw28al0wd7";
      })
    ];
  });

  wlroots_0_17 = super.wlroots.overrideAttrs (old: rec {
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "6dce6ae2ed92544b9758b194618e21f4c97f1d6b";
      hash = "sha256-Of9qykyVnBURc5A2pvCMm7sLbnuuG7OPWLxodQLN2Xg=";
    };

    buildInputs = old.buildInputs
      ++ (with super; [ glslang libdrm.dev mesa.dev ]);

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
  # wineUsingFull = super.wineWowPackages.stagingFull;

  yabridge = super.yabridge.override { wine = self.wineUsingFull; };
  yabridtctl = super.yabridgectl.override {
    inherit (self) yabridge;
    wine = self.wineUsingFull;
  };

  waybar = super.waybar.override {
    swaySupport = false;
    hyprlandSupport = false;
  };
}
