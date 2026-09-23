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
  name = "pi";
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
      allowedDomains = [
        "*.anthropic.com"
        "api.ai.sakura.ad.jp"
        "api.openai.com"
        "opencode.ai"
        "pi.dev"

        "127.0.0.1"
        "localhost"

        "*.npmjs.org"
        "registry.npmjs.org"
      ];
      allowLocalOutbound = true;
      allowLocalOutboundPorts = [ 11343 ];
    };
  };

  extraInit = ''
    export PATH=${PATH}:$PATH
  '';
}
