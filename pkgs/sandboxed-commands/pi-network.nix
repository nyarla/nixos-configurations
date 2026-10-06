{
  callPackage,

  lib,

  bun,
  gitFull,
  iconv,
  nodejs,
  python3,

  pi-coding-agent,
}:
let
  PATH = lib.makeBinPath [
    bun
    gitFull
    iconv
    nodejs
    python3
  ];
in
callPackage ./wrapper.nix {
  name = "pi-network";
  cmd = "${pi-coding-agent}/bin/pi";
  settings = {
    extends = "@base";
    filesystem = {
      allowGitConfig = false;
      allowRead = [
        "."
        "~/.pi/secrets/"
      ];
      allowWrite = [
        "."
        "~/.npm"
        "~/.pi/agent/"
      ];
      defaultDenyRead = true;
    };

    network = {
      allowedDomains = [ "*" ];
      allowLocalOutbound = true;
      allowLocalOutboundPorts = [ 11343 ];
    };
  };

  extraInit = ''
    export PATH=${PATH}:$PATH
  '';
}
