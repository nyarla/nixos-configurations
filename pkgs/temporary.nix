self: super:
let require = path: super.callPackage (import path);
in {
  quodlibet = super.quodlibet.overrideAttrs (old: rec {
    doInstallCheck = false;
    nativeBuildInputs = old.nativeBuildInputs
      ++ [ super.gobject-introspection ];
  });

  cnijfilter2 = super.cnijfilter2.overrideAttrs
    (old: rec { NIX_CFLAGS_COMPILE = " -fcommon"; });

  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });

  tt-rss = super.tt-rss.overrideAttrs (old: rec {
    pname = "tt-rss";
    version = "2022-10-08";
    src = super.fetchgit {
      url = "https://git.tt-rss.org/fox/tt-rss.git";
      rev = "68dee4578230306da895d5090b7997d8dd23952e";
      sha256 = "1pr1wx0bg79hivrmlw2gvjprlmvvrc00jai7bi7yy96s5vns8jwz";
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
    version = "2022-10-08";
    src = super.fetchFromGitHub {
      owner = "levito";
      repo = "tt-rss-feedly-theme";
      rev = "d9657718eb4a8aeabffab7660ea336c72db811fb";
      sha256 = "1isvkxsj1wn77xghrfxjgqgh9vrnw8cqs4gbg12fj4nlzk66nsmb";
    };
  });
}
