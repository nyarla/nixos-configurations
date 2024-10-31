{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  buildFHSUserEnv,
}:

let
  app = buildDotnetModule rec {
    pname = "StabilityMatrix";
    version = "2.12.2";

    src = fetchFromGitHub {
      owner = "LykosAI";
      repo = pname;
      rev = version;
      hash = "sha256-MWENjkS9qpUGNVh4la2e60nb/jALNoEDBL0OTM1nIUw=";
    };

    patches = [
      ./nixos.patch
    ];

    projectFile = "StabilityMatrix.sln";
    nugetDeps = ./deps.nix;

    dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
    dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;

    preConfigure = ''
      dotnet tool uninstall husky
      dotnet tool uninstall xamlstyler.console
      dotnet tool uninstall csharpier

      export HUSKY=0
    '';

    executables = [ "StabilityMatrix.Avalonia" ];
    runtimeId = "linux-x64";
  };
in
buildFHSUserEnv {
  name = "StabilityMatrix";
  targetPkgs =
    p:
    (
      with p;
      [
        python310
        libxcrypt-legacy
      ]
      ++ python310.buildInputs
    )
    ++ [ app ];

  runScript = "${app}/bin/StabilityMatrix.Avalonia";
}
