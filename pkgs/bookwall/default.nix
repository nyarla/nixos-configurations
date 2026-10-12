{
  stdenvNoCC,

  fetchFromGitHub,
  fetchNpmDeps,
  autoPatchelfHook,

  bundlerEnv,
  defaultGemConfig,

  ruby_4_0,
  rubyPackages,
  nodejs_26,
  npmHooks,
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

  pname = "bookwall";
  version = "2026-09-03";

  gems = bundlerEnv {
    inherit ruby;
    name = "${pname}-ruby-gems";
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
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    gems
    gems.wrappedRuby
    nodejs_26
    npmHooks.npmConfigHook
  ];

  npmRoot = "client";
  npmDepsHash = "sha256-x2XSg9HYLHsEUYSeO5rKONSgB7g6ybiegRk3J1jZIK0=";
  npmDeps = fetchNpmDeps {
    pname = "${pname}-npm-deps";
    inherit src;

    preBuild = ''
      pushd ${finalAttrs.npmRoot}
    '';

    hash = finalAttrs.npmDepsHash;
  };

  buildInputs = [
    gems
  ];

  preConfigure = ''
    pushd ${finalAttrs.npmRoot}
    npm install
    npm run build
    popd

    cd server
  '';

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
    cp -r ../client/dist $out/public/ui

    for bin in $(ls ${gems.wrappedRuby}/bin); do
      cp ${gems.wrappedRuby}/bin/$bin $out/bin/
    done

    runHook postInstall
  '';
})
