self: super:
let
  require = path: super.callPackage (import path);
in
{
  # additional packages
  audiogridder = require ./audiogridder { };
  cskk = require ./cskk { };
  cuda-shell = require ./cuda-shell {
    cudaPackages = super.cudaPackages_11_8;
    nvidia_x11 = null;
  };
  currennt = require ./currennt { inherit (super.cudaPackages) cudatoolkit; };
  deadbeef-fb = require ./deadbeef-fb { };
  fcitx5-fbterm = require ./fcitx5-fbterm { };
  fcitx5-cskk = super.libsForQt5.callPackage (import ./fcitx5-cskk) { };
  fcitx5-cskk-qt = self.fcitx5-cskk.override { enableQt = true; };
  galendae = require ./galendae { };
  goreman = require ./goreman { };
  gyazo-diy = require ./gyazo-diy { };
  igsc = require ./igsc { };
  ildaeil = require ./ildaeil {
    inherit (self) carla;
    wine = self.wineUsingFull;
  };
  kaunas = require ./kaunas { };
  nvim-run = require ./nvim-run { };
  openjtalk = require ./openjtalk { };
  noto-fonts-jp = require ./noto-fonts-jp { };
  perl-shell = require ./perl-shell { };
  restic-run = require ./restic-run { };
  shoreman = require ./shoreman { };
  skk-dicts-xl = require ./skk-dicts-xl { };
  sononym-bin = require ./sononym-bin { };
  vgpu_unlock-rs = require ./vgpu_unlock-rs { };
  wine-run = require ./wine-run { };
  wine-vst-wrapper = require ./wine-vst-wrapper { };
  wineasio = require ./wineasio { wine = self.wineUsingFull; };
  xembed-sni-proxy = require ./xembed-sni-proxy { };

  # modified packages
  bitwig-sutido3 = super.bitwig-sutido3.overrideAttrs (old: rec {
    version = "3.3.11";
    src = super.fetchurl {
      url = "https://downloads.bitwig.com/stable/${version}/${old.pname}-${version}.deb";
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

  firefox-bin-unwrapped = super.firefox-bin-unwrapped.override { systemLocale = "ja_JP"; };

  labwc = super.labwc.overrideAttrs (old: {
    version = "0.7.4";
    src = super.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "71136fdf65940b4e924dea7f8285d2a21032755";
      hash = "sha256-7MH1mMfyMkaTVwEBJWvI1Lt3M6kosXOwkowuBTZej3c=";
    };

    patches = [
      (super.fetchpatch {
        name = "text-input-v1.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-IME-support-text-input-v1.patch?h=labwc-im&id=ab3f16a1f0af8db52d88b6b69695e2a2b548fc14";
        hash = "sha256-r3a42DY2KD9o2G5WYAiwo44D135BHUpQHao6amq7N6Q=";
      })
    ];
  });

  platinum-searcher = super.platinum-searcher.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "ad20073a3cb5bb354a1fde44ffe5aa331982cbd1";
      sha256 = "sha256-FNHlALFwMbajaHWOehdSFeQmvZSuCZLdqGqLZ7DF+pI=";
    };
  });

  speechd-with-openjtalk = super.speechd.overrideAttrs (old: rec {
    src = super.fetchurl {
      url = "https://github.com/brailcom/speechd/releases/download/0.12.0-rc3/speech-dispatcher-0.12.0-rc3.tar.gz";
      hash = "sha256-vStiv9z3RVKs2F6dpOQv0f8SuOoYYQpqG9aDXfdntmM=";
    };
    buildInputs = old.buildInputs ++ [ self.openjtalk ];
    configureFlags = old.configureFlags ++ [ "--with-openjtalk" ];
  });

  thunderbird-bin-unwrapped = super.thunderbird-bin-unwrapped.override { systemLocale = "ja_JP"; };

  tmux = super.tmux.overrideAttrs (old: rec {
    patches =
      let
        # remove sixel patch.
        # this patch confict to between tmux-eaw-patch
        patches' = super.lib.lists.remove (super.lib.lists.last old.patches) old.patches;
      in
      patches'
      ++ [
        # this patch is modified for nvim rounded border.
        # DO NOT REPLACE TO OTHERS.
        ../patches/tmux-3.4-fix.diff
      ];
  });

  # wineUsingFull = super.lib.overrideDerivation super.wineWowPackages.stagingFull (old: rec {
  #   buildInputs =
  #     old.buildInputs
  #     ++ (with super; [
  #       libgcrypt.dev
  #       libva.dev
  #     ])
  #     ++ (with super.pkgsi686Linux; [
  #       libgcrypt.dev
  #       libva.dev
  #     ]);

  #   configureFlags = old.configureFlags ++ [
  #     "--with-va"
  #     "--with-gcrypt"
  #     "--disable-test"
  #   ];
  # });
  wineUsingFull = super.wineWowPackages.stagingFull;

  yabridge = super.yabridge.override { wine = self.wineUsingFull; };
  yabridtctl = super.yabridgectl.override {
    inherit (self) yabridge;
    wine = self.wineUsingFull;
  };
}
