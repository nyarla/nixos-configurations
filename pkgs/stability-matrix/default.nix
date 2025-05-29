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
    version = "2.14.2";

    src = fetchFromGitHub {
      owner = "LykosAI";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-vusbubTTEHQlskp+T30bhFNDmsEzTYwTEp4W3b8xXLw=";
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

    dotnet-runtime = dotnetCorePackages.runtime_9_0;
    dotnet-sdk = dotnetCorePackages.sdk_9_0;

    preConfigure = ''
      dotnet tool uninstall husky
      dotnet tool uninstall xamlstyler.console
      dotnet tool uninstall csharpier
      dotnet tool uninstall dotnet-script
      dotnet tool uninstall refitter

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
