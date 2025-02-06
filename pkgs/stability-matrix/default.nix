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
    version = "2.13.3";

    src = fetchFromGitHub {
      owner = "LykosAI";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-/EjciXJR6GCoEOjKv4qQW/Xzshs9NpnMv+ObrxQ0nwM=";
    };

    patches = [
      ./nixos.patch
    ];

    postPatch = ''
      # workaround for my environment
      sed -i 's!RegisterUriSchemeLinux();!/* RegisterUriSchemeLinux(); */!' \
        StabilityMatrix.Avalonia/Helpers/UriHandler.cs
    '';

    projectFile = "StabilityMatrix.Avalonia/StabilityMatrix.Avalonia.csproj";
    nugetDeps = ./deps.nix;

    dotnet-runtime = dotnetCorePackages.dotnet_9.runtime;
    dotnet-sdk = dotnetCorePackages.dotnet_9.sdk;

    preConfigure = ''
      dotnet tool uninstall husky
      dotnet tool uninstall xamlstyler.console
      dotnet tool uninstall csharpier
      dotnet tool uninstall dotnet-script

      export HUSKY=0
    '';

    executables = [ "StabilityMatrix.Avalonia" ];
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
