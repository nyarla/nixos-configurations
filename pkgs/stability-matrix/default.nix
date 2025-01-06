{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  buildFHSEnv,
  writeShellScript,
}:

let
  app = buildDotnetModule rec {
    pname = "StabilityMatrix";
    version = "2.12.3";

    src = fetchFromGitHub {
      owner = "LykosAI";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-LapdC522CMfe1UI+dbw+PkkNIY+9hEftsV8IQppxsXM=";
    };

    patches = [
      ./nixos.patch
    ];

    postPatch = ''
      # workaround for my environment
      sed -i 's!RegisterUriSchemeLinux();!/* RegisterUriSchemeLinux(); */!' \
        StabilityMatrix.Avalonia/Helpers/UriHandler.cs
    '';

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
buildFHSEnv {
  name = "StabilityMatrix";
  targetPkgs =
    p:
    (
      with p;
      [
        python310Full

        # dependences for pytyon 3.10.x runtime
        expat
        glib
        libGL
        libxcrypt-legacy
        tcl
        tclx
        tix
        tk
        xorg.libX11
        xorg.xorgproto
        zlib
      ]
      ++ python310Full.buildInputs
    )
    ++ [ app ];

  # # workaround for my environment
  runScript = toString (
    writeShellScript "StabilityMatrix" ''
      export HOME=/persist/home/nyarla
      export XDG_CONFIG_HOME=$HOME/.config
      export XDG_DATA_HOME=$HOME/.local/share
      export XDG_STATE_HOME=$HOME/.local/state

      exec -a StabilityMatrix.Avalonia ${app}/bin/StabilityMatrix.Avalonia ''${@:-};
    ''
  );
}
