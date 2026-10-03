{
  stdenvNoCC,

  fetchFromGitHub,
  autoPatchelfHook,

  bundlerEnv,
  defaultGemConfig,

  ruby_4_0,
  rubyPackages,
  nodejs_26,
  cacert,
  libxslt,
  libxml2,
  sqlite,
  pkg-config,

}:
let
  ruby = ruby_4_0;

  src = fetchFromGitHub {
    owner = "joker1007";
    repo = "bookwall";
    rev = "8cfa0e3b0e1a366594e695ad42fcaa2aed1d7b2a";
    hash = "sha256-Q1r6pjF9XREawxXVX3XTOrSNAE9LkHpV5jEMMdIl26c=";
  };

  client = stdenvNoCC.mkDerivation {
    pname = "bookwall-client-dist";
    version = "2026-09-30";
    inherit src;

    sourceRoot = "source/client";

    nativeBuildInputs = [
      nodejs_26
      cacert
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)

      substituteInPlace package.json \
        --replace-fail '"postinstall": "patch-package",' ""

      npm ci
      node node_modules/.bin/patch-package

      node node_modules/.bin/tsc -b
      node node_modules/.bin/vite build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv dist $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "SHA256";
    outputHash = "sha256-DPVTO7sFJGe0a35LglXx3m+oGFZSjfKrDsPcQqYyW14=";
  };

  gems = bundlerEnv {
    inherit ruby;
    name = "bookwall-server-gems";
    gemdir = "${src}/server";
    gemset = ./gemset.nix;
    gemConfig = defaultGemConfig // {
      ffi = _: {
        platform = "x86_64-linux-gnu";
        nativeBuildInputs = [ autoPatchelfHook ];
      };

      nokogiri = _: {
        platform = "x86_64-linux-gnu";
        nativeBuildInputs = [ autoPatchelfHook ];
        buildInputs = [
          libxslt
          libxml2
          rubyPackages.mini_portile2
        ];
      };

      sqlite3 = _: {
        platform = "x86_64-linux-gnu";
        nativeBuildInputs = [ autoPatchelfHook ];
        buildInputs = [
          sqlite
          pkg-config
        ];
      };

      thruster = _: {
        platform = "x86_64-linux";
        nativeBuildInputs = [ autoPatchelfHook ];
      };
    };
  };

in
stdenvNoCC.mkDerivation {
  pname = "bookwall";
  version = "2026-09-30";
  inherit src;

  sourceRoot = "source/server";

  nativeBuildInputs = [
    gems
    gems.wrappedRuby
  ];

  buildInputs = [
    client
    gems
  ];

  buildPhase = ''
    runHook preBuild

    export SECRET_KEY_BASE_DUMMY=1
    export RAILS_ENV=production
    export BUNDLE_WITHOUT="development:test"

    patchShebangs bin
    bundle exec bootsnap precompile --gemfile
    bundle exec bootsnap precompile app/ lib/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/

    mv * $out/
    cp -r ${client}/dist $out/public/ui

    for bin in $(ls ${gems.wrappedRuby}/bin); do
      cp ${gems.wrappedRuby}/bin/$bin $out/bin/
    done

    runHook postInstall
  '';
}
